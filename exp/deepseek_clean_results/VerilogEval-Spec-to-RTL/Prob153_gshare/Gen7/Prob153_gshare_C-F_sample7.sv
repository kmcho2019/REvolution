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

    // Function to update saturating counter (optimized version)
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            if (taken)
                update_counter = (current == 2'b11) ? 2'b11 : current + 1;
            else
                update_counter = (current == 2'b00) ? 2'b00 : current - 1;
        end
    endfunction

    // Pattern History Table (128 entries)
    reg [1:0] pht [0:127];
    
    // Global History Registers
    reg [6:0] ghr;          // Current prediction GHR
    reg [6:0] next_ghr;     // Next GHR value
    
    // Prediction path (combinational)
    wire [6:0] predict_index = predict_valid ? (predict_pc ^ ghr) : 7'b0;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;
    
    // Training path (combinational)
    wire [6:0] train_index = train_valid ? (train_pc ^ train_history) : 7'b0;
    
    // GHR update logic (priority to training)
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