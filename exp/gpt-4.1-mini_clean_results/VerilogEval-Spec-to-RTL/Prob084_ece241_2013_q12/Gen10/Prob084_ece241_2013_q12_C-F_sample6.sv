module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output reg Z
);

    // 8-bit shift register holding memory contents:
    // Q[0] is the MSB where new bits (S) are shifted in first
    reg [7:0] Q;

    // Synchronous shift operation on positive clock edge:
    // Shift left (towards higher indices) with S into Q[0] when enable is high
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Combinational multiplexer selecting output Z based on 3-bit selector {A,B,C}
    always @(*) begin
        case ({A,B,C})
            3'b000: Z = Q[0];
            3'b001: Z = Q[1];
            3'b010: Z = Q[2];
            3'b011: Z = Q[3];
            3'b100: Z = Q[4];
            3'b101: Z = Q[5];
            3'b110: Z = Q[6];
            3'b111: Z = Q[7];
            default: Z = 1'bx; // Defensive coding, should never occur
        endcase
    end

endmodule