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

    // Combinational prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;

    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;

    // Counter update logic
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

    // Next GHR value calculation with clear priority
    reg [6:0] next_ghr;
    always @(*) begin
        if (areset) begin
            next_ghr = 7'b0;
        end else if (train_valid && train_mispredicted) begin
            next_ghr = {train_history[5:0], train_taken};
        end else if (train_valid) begin
            next_ghr = {ghr[5:0], train_taken};
        end else if (predict_valid) begin
            next_ghr = {ghr[5:0], predict_taken};
        end else begin
            next_ghr = ghr;
        end
    end

    // Initialize PHT and GHR on reset, update on clock edges
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            // Update GHR
            ghr <= next_ghr;
            
            // Update PHT on training (synchronous)
            if (train_valid) begin
                pht[train_index] <= update_counter(pht[train_index], train_taken);
            end
        end
    end

endmodule