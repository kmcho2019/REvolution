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

    // Function to update saturating counter (optimized)
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            case (current)
                2'b00: update_counter = taken ? 2'b01 : 2'b00;
                2'b01: update_counter = taken ? 2'b10 : 2'b00;
                2'b10: update_counter = taken ? 2'b11 : 2'b01;
                2'b11: update_counter = taken ? 2'b11 : 2'b10;
            endcase
        end
    endfunction

    // Pattern History Table (128 entries)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;
    
    // Prediction path (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;
    
    // Training path (combinational)
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Next GHR value calculation
    reg [6:0] next_ghr;
    always @(*) begin
        if (train_valid && train_mispredicted)
            next_ghr = {train_history[5:0], train_taken};
        else if (predict_valid)
            next_ghr = {ghr[5:0], predict_taken};
        else
            next_ghr = ghr;
    end
    
    // Sequential updates
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            // Update PHT if training
            if (train_valid)
                pht[train_index] <= update_counter(pht[train_index], train_taken);
            
            // Update GHR
            ghr <= next_ghr;
        end
    end

endmodule