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

    // Stack Pointer: values 0 to 4 inclusive; 
    // SP == 4 means empty; SP == 0 means full
    reg [2:0] SP;

    // EMPTY and FULL flags derived combinationally from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset stack pointer and dataOut only
            SP <= 3'd4;
            dataOut <= 4'd0;
            // Do NOT explicitly clear stack_mem to save reset time and area.
            // If required, this can be added with synthesis pragmas.
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation: only if not full
                if (SP != 3'd0) begin
                    // Decrement SP and write dataIn to new top of stack
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    // dataOut unchanged on write
                end
                // else full: no operation, hold state
            end else begin
                // Read (pop) operation: only if not empty
                if (SP != 3'd4) begin
                    // Read data from current top of stack
                    dataOut <= stack_mem[SP];
                    // Increment SP to pop
                    SP <= SP + 1;
                    // Do NOT clear popped memory location
                end
                // else empty: no operation, dataOut unchanged
            end
        end
        // If EN low: hold state, no changes
    end

endmodule