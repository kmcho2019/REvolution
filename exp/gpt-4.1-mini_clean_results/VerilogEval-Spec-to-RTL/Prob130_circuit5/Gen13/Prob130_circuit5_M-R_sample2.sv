module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    reg [3:0] q_reg;

    always @(*) begin
        case (c)
            4'd0: q_reg = b;
            4'd1: q_reg = e;
            4'd2: q_reg = a;
            4'd3: q_reg = d;
            default: q_reg = 4'hF;
        endcase
    end

    assign q = q_reg;

endmodule