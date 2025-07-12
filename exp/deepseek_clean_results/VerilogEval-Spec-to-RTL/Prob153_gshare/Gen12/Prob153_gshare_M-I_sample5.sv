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

    // Function for saturating counter update (optimized version)
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = taken ? (|current ? {1'b1, current[0]} : 2'b01) 
                                 : (&current ? 2'b10 : {1'b0, current[1]});
        end
    endfunction

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];
    reg [6:0] pht_reset_ptr;

    // Shared XOR logic
    wire [6:0] shared_xor = predict_valid ? (predict_pc ^ ghr) : (train_pc ^ train_history);
    reg [6:0] predict_index_reg;
    
    // Prediction outputs
    assign predict_taken = pht[predict_index_reg][1];
    assign predict_history = ghr;

    // Clock gating control
    wire ghr_update_en = predict_valid || (train_valid && train_mispredicted);

    // PHT update logic with partial reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Partial reset - initialize only first entry
            pht[0] <= 2'b01;
            pht_reset_ptr <= 7'd1;
        end else begin
            if (pht_reset_ptr < 127) begin
                pht[pht_reset_ptr] <= 2'b01;
                pht_reset_ptr <= pht_reset_ptr + 1;
            end
            if (train_valid) begin
                pht[shared_xor] <= update_counter(pht[shared_xor], train_taken);
            end
        end
    end

    // Pipeline stage for prediction index
    always @(posedge clk) begin
        if (predict_valid) begin
            predict_index_reg <= shared_xor;
        end
    end

    // GHR update logic (pipelined)
    reg [6:0] next_ghr;
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            next_ghr = {train_history[5:0], train_taken};
        end else if (predict_valid) begin
            next_ghr = {ghr[5:0], predict_taken};
        end else begin
            next_ghr = ghr;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else if (ghr_update_en) begin
            ghr <= next_ghr;
        end
    end

endmodule