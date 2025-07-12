module TopModule(
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [3:0] c,
    input  wire [3:0] d,
    input  wire [3:0] e,
    output wire [3:0] q
);

    wire [3:0] lut_output;

    always @(*) begin
        case (c)
            4'b0000: lut_output = b;
            4'b0001: lut_output = e;
            4'b0010: lut_output = a;
            4'b0011: lut_output = d;
            default: lut_output = 4'b1111; // Assuming f as all ones for c > 3
        endcase
    end

    assign q = lut_output;

endmodule