module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Registered index calculation for timing
    reg [6:0] predict_index_reg;
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire pht_access_en = predict_valid | train_valid;

    // Prediction is combinational using registered index
    assign predict_taken = pht_access_en ? pht[predict_index_reg][1] : 1'b0;
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT update logic
    wire do_train = train_valid & pht_access_en;
    wire inc_counter = train_taken & (pht[train_index] != 2'b11);
    wire dec_counter = ~train_taken & (pht[train_index] != 2'b00);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Optimized reset using parameterized initialization
            ghr <= 7'b0;
            predict_index_reg <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Register index calculation
            predict_index_reg <= predict_index;

            // Handle training (higher priority)
            if (do_train) begin
                // Arithmetic PHT update (simpler than case statement)
                if (inc_counter) pht[train_index] <= pht[train_index] + 1;
                else if (dec_counter) pht[train_index] <= pht[train_index] - 1;

                // Misprediction recovery
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end
            end
            
            // Handle prediction if no training or no misprediction recovery
            if (predict_valid && pht_access_en && (!train_valid || !train_mispredicted)) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule