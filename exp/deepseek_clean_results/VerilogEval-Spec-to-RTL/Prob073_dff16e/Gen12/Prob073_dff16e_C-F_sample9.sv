module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_ff
            reg q_reg;
            always @(posedge clk) begin
                if (!resetn) begin
                    q_reg <= 1'b0;
                end else if (enable) begin
                    q_reg <= d[i];
                end
            end
            assign q[i] = q_reg;
        end
    endgenerate

endmodule

module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Instantiate two byte registers with explicit parameter passing
    ByteRegister #(.WIDTH(8)) upper_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[1]),
        .d(d[15:8]),
        .q(q[15:8])
    );

    ByteRegister #(.WIDTH(8)) lower_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[0]),
        .d(d[7:0]),
        .q(q[7:0])
    );

endmodule