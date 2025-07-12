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
    (* ram_style = "distributed" *) reg [1:0] pht [0:127];
    
    // Pipeline register for prediction path
    reg predict_taken_reg;
    assign predict_taken = predict_taken_reg;
    assign predict_history = ghr;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire pht_write_en = train_valid && ~areset;
    reg [1:0] updated_counter;
    wire [1:0] current_counter = pht[train_index];
    
    // Optimized saturating counter logic
    always @(*) begin
        if (train_taken) begin
            updated_counter = current_counter + (current_counter != 2'b11);
        end else begin
            updated_counter = current_counter - (current_counter != 2'b00);
        end
    end

    // Prediction logic (pipelined)
    reg [6:0] predict_index_reg;
    always @(posedge clk) begin
        if (predict_valid) begin
            predict_index_reg <= predict_pc ^ ghr;
        end
    end
    
    always @(posedge clk) begin
        predict_taken_reg <= pht[predict_index_reg][1];
    end

    // Update PHT and GHR
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
            predict_taken_reg <= 1'b0;
        end else begin
            // PHT update with clock gating
            if (pht_write_en) begin
                pht[train_index] <= updated_counter;
            end
            
            // GHR update - training has priority
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid && (!train_valid || !train_mispredicted)) begin
                ghr <= {ghr[5:0], pht[predict_index_reg][1]};
            end
        end
    end

endmodule