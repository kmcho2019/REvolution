module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write(push), 1: read(pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);
    // Stack memory: 4 entries of 4-bit width
    reg [3:0] stack_mem [3:0];

    // Stack pointer: counts number of stored entries, 0 to 4
    reg [2:0] SP;

    // Derived push and pop enables
    wire push_en  = EN & ~RW & (~FULL);
    wire pop_en   = EN & RW & (~EMPTY);

    // Flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Optional: no need to clear stack_mem, leave as is to save power
        end else begin
            // Push operation
            if (push_en) begin
                stack_mem[SP] <= dataIn; // Write data at current SP location
                SP <= SP + 1'b1;         // Increment SP
            end
            // Pop operation
            else if (pop_en) begin
                SP <= SP - 1'b1;         // Decrement SP first
                dataOut <= stack_mem[SP - 1]; // Output data at new SP location
                // No clearing of stack_mem required to reduce switching
            end
        end
    end
endmodule