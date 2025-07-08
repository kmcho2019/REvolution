module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0]; // 4 entries of 4-bit width
    reg [2:0] SP; // stack pointer, range 0 to 4 (3 bits to represent 5 states)

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                SP <= 3'd4;          // Empty stack pointer points beyond top (4)
                dataOut <= 4'b0;
                EMPTY <= 1'b1;
                FULL  <= 1'b0;
                for (i = 0; i < 4; i = i + 1) begin
                    stack_mem[i] <= 4'b0;
                end
            end else begin
                // Default outputs to current outputs to avoid latches
                dataOut <= dataOut;

                if (RW == 1'b0) begin
                    // Write operation (push)
                    if (SP != 0) begin
                        // Not full
                        SP <= SP - 1;
                        stack_mem[SP - 1] <= dataIn;
                        dataOut <= dataOut; // unchanged
                    end
                    // else full, no write
                end else begin
                    // Read operation (pop)
                    if (SP != 4) begin
                        // Not empty
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'b0;
                        SP <= SP + 1;
                    end else begin
                        // Empty, no pop
                        dataOut <= dataOut;
                    end
                end

                // Update flags
                EMPTY <= (SP == 4);
                FULL  <= (SP == 0);
            end
        end
    end

endmodule