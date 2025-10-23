module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Count of entries in the stack (0 to 4)
    reg [2:0] count;

    // Top pointer index (0 to 3), valid only if count > 0
    wire [1:0] top_index = count - 1;

    assign EMPTY = (count == 3'd0);
    assign FULL  = (count == 3'd4);

    // Gating signals for push and pop
    wire push_en = EN && (RW == 1'b0) && !FULL;
    wire pop_en  = EN && (RW == 1'b1) && !EMPTY;

    always @(posedge Clk) begin
        if (Rst) begin
            count <= 3'd0;
            dataOut <= 4'd0;
            // Do not clear stack_mem to save reset time and power
        end else begin
            if (push_en) begin
                // Push operation: write dataIn at current count index, then increment count
                stack_mem[count] <= dataIn;
                count <= count + 1;
            end else if (pop_en) begin
                // Pop operation: output data at top_index, then decrement count
                dataOut <= stack_mem[top_index];
                count <= count - 1;
                // No memory clearing to reduce switching
            end
            // If EN low or no valid operation, hold dataOut and count
        end
    end

endmodule