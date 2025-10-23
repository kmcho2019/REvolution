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

    // Pattern History Table (128 entries of 2-bit saturating counters)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;
    
    // Prediction index and output
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;
    
    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Counter update function (clear and concise)
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
    
    // Next GHR value calculation (priority to training)
    reg [6:0] next_ghr;
    always @(*) begin
        if (train_valid && train_mispredicted)
            next_ghr = {train_history[5:0], train_taken};
        else if (predict_valid)
            next_ghr = {ghr[5:0], predict_taken};
        else
            next_ghr = ghr;
    end
    
    // Initialize and update state
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT to weakly not-taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            // Update PHT for training (synchronous)
            if (train_valid)
                pht[train_index] <= update_counter(pht[train_index], train_taken);
            
            // Update GHR (priority handled by next_ghr calculation)
            ghr <= next_ghr;
        end
    end

endmodule