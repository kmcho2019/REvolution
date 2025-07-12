module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,      // 0: push, 1: pop
    input  wire [3:0] dataIn,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    // Memory: 4 entries of 4 bits
    reg [3:0] stack_mem [3:0];

    // Stack depth pointer (0 to 4)
    reg [2:0] SP;

    // Top index pointer for circular buffer (0 to 3)
    reg [1:0] top_idx;

    // Flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Internal variables for next states
    reg [2:0] SP_next;
    reg [1:0] top_idx_next;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            top_idx <= 2'd0;
            dataOut <= 4'd0;
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP != 3'd4) begin
                    stack_mem[top_idx] <= dataIn;
                    SP <= SP + 1;
                    top_idx <= (top_idx + 1) & 2'b11;
                end
                // If full, ignore push
            end else begin
                // Pop operation
                if (SP != 3'd0) begin
                    // Calculate new top index (previous element)
                    top_idx <= (top_idx - 1) & 2'b11;
                    SP <= SP - 1;
                    // Output data at new top index after decrement
                    dataOut <= stack_mem[(top_idx - 1) & 2'b11];
                end
                // If empty, ignore pop, dataOut unchanged
            end
        end
        // If EN low, no change
    end

endmodule