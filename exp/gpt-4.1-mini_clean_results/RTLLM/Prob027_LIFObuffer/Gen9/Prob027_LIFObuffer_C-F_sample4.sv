module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,        // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [3:0];

    // Stack pointer: number of elements currently in stack (0 to 4)
    reg [2:0] SP;

    // Combinational flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear stack memory and reset SP and dataOut
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn; // write input at current SP (next free slot)
                    SP <= SP + 1;            // increment pointer
                    // dataOut remains unchanged on push
                end
                // else full: no operation
            end else begin
                // Pop operation
                if (SP > 0) begin
                    SP <= SP - 1;            // decrement pointer first
                    dataOut <= stack_mem[SP - 1]; // then update output with popped element
                    // stack_mem location is not cleared to reduce toggling
                end
                // else empty: no operation, dataOut holds previous value
            end
        end
        // else EN low: no operation, maintain current state
    end

endmodule