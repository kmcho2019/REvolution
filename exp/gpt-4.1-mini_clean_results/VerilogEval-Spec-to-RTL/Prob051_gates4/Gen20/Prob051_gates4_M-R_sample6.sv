module FourInputGate #(parameter GATETYPE = "AND") (
    input  [3:0] in,
    output reg    out
);
    reg level1_0, level1_1;

    always @(*) begin
        case (GATETYPE)
            "AND": begin
                level1_0 = in[0] & in[1];
                level1_1 = in[2] & in[3];
                out = level1_0 & level1_1;
            end
            "OR": begin
                level1_0 = in[0] | in[1];
                level1_1 = in[2] | in[3];
                out = level1_0 | level1_1;
            end
            "XOR": begin
                level1_0 = in[0] ^ in[1];
                level1_1 = in[2] ^ in[3];
                out = level1_0 ^ level1_1;
            end
            default: begin
                level1_0 = 1'b0;
                level1_1 = 1'b0;
                out = 1'b0;
            end
        endcase
    end
endmodule

module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    FourInputGate #(.GATETYPE("AND")) u_and (.in(in), .out(out_and));
    FourInputGate #(.GATETYPE("OR"))  u_or  (.in(in), .out(out_or));
    FourInputGate #(.GATETYPE("XOR")) u_xor (.in(in), .out(out_xor));
endmodule