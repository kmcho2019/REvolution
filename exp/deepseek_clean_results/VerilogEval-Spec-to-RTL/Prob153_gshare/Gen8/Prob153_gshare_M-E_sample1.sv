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

    // Dual-ported PHT implementation
    reg [1:0] pht [0:127];
    wire [1:0] pht_rd_data;
    reg [6:0] pht_rd_addr;
    reg [6:0] pht_wr_addr;
    reg [1:0] pht_wr_data;
    reg pht_wr_en;

    // Separate speculative and committed GHRs
    reg [6:0] ghr_speculative;
    reg [6:0] ghr_committed;

    // PHT read port (for prediction)
    assign pht_rd_data = pht[pht_rd_addr];
    
    // PHT write port (for training)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else if (pht_wr_en) begin
            pht[pht_wr_addr] <= pht_wr_data;
        end
    end

    // Saturating counter update function
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = taken ? 
                (current == 2'b11 ? 2'b11 : current + 1) :
                (current == 2'b00 ? 2'b00 : current - 1);
        end
    endfunction

    // Prediction logic (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr_speculative;
    assign predict_taken = pht_rd_data[1];
    assign predict_history = ghr_speculative;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] train_pht_value = pht[train_index];

    // Main operational logic
    always @(*) begin
        // Default assignments
        pht_wr_en = 1'b0;
        pht_wr_addr = 7'b0;
        pht_wr_data = 2'b0;
        pht_rd_addr = predict_index;

        // Training takes priority
        if (train_valid) begin
            pht_wr_en = 1'b1;
            pht_wr_addr = train_index;
            pht_wr_data = update_counter(train_pht_value, train_taken);
        end
    end

    // GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_speculative <= 7'b0;
            ghr_committed <= 7'b0;
        end else begin
            // Update committed GHR only on training
            if (train_valid) begin
                if (train_mispredicted) begin
                    ghr_committed <= {train_history[5:0], train_taken};
                    ghr_speculative <= {train_history[5:0], train_taken};
                end else begin
                    ghr_committed <= {ghr_committed[5:0], train_taken};
                end
            end
            
            // Always update speculative GHR on prediction
            if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr_speculative <= {ghr_speculative[5:0], predict_taken};
            end
        end
    end

endmodule