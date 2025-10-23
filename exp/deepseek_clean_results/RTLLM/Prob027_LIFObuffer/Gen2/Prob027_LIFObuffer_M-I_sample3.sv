module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (0-4) using efficient encoding
    reg [2:0] SP;
    // Operation valid signal
    wire op_valid = EN && ((!RW && !FULL) || (RW && !EMPTY));

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: set SP to empty (4)
            SP <= 3'd4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (op_valid) begin
            if (!RW) begin
                // Write operation (push)
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
            end
            else begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
                SP <= SP + 1;
            end
        end
    end

    // Flag generation (combinational)
    always @(*) begin
        EMPTY = (SP == 3'd4);
        FULL = (SP == 3'd0);
    end

endmodule