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

    // Function to update saturating counter
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = taken ? 
                (current == 2'b11 ? 2'b11 : current + 1) :
                (current == 2'b00 ? 2'b00 : current - 1);
        end
    endfunction

    // Pattern History Table (128 entries)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;
    
    // Prediction path
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Next GHR value calculation
    reg [6:0] next_ghr;
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            // Training has priority, recover history
            next_ghr = {train_history[5:0], train_taken};
        end else if (predict_valid) begin
            // Normal prediction update
            next_ghr = {ghr[5:0], predict_taken};
        end else begin
            // No update
            next_ghr = ghr;
        end
    end
    
    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b01)
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Update PHT if training
            if (train_valid) begin
                pht[train_index] <= update_counter(pht[train_index], train_taken);
            end
            
            // Update GHR
            ghr <= next_ghr;
        end
    end

endmodule