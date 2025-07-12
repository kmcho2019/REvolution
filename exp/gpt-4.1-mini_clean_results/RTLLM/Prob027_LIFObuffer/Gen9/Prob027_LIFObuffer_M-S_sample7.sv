module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,      // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries, 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: number of elements currently in stack (0 to 4)
    reg [2:0] SP;

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // No need to clear stack_mem to reduce complexity
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (!FULL) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else full: do nothing
            end else begin
                // Pop operation
                if (!EMPTY) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                end
                // else empty: do nothing
            end
        end
        // else EN low: no operation
    end

endmodule