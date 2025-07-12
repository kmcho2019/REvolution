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

    reg [3:0] stack_mem [3:0];   // Stack memory: 4 x 4 bits
    reg signed [2:0] SP;         // Stack pointer: -1 (empty) to 3 (full)

    // Flags combinationally from SP value
    assign EMPTY = (SP == -1);
    assign FULL  = (SP == 3);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= -1;              // Empty stack
            dataOut <= 4'd0;       // Clear output
            // stack_mem left as-is for less reset overhead
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < 3) begin
                    SP <= SP + 1;
                    stack_mem[SP + 1] <= dataIn;
                    // dataOut not updated on push
                end
                // else full: no push
            end else begin
                // Pop operation
                if (SP >= 0) begin
                    dataOut <= stack_mem[SP];
                    SP <= SP - 1;
                end
                // else empty: no pop, dataOut unchanged
            end
        end
        // else EN low: hold states
    end

endmodule