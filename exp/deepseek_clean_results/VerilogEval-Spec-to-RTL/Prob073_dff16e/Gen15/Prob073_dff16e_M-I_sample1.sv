module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    wire gated_clk;
    assign gated_clk = clk & (enable | ~resetn);

    always @(posedge gated_clk) begin
        if (!resetn) begin
            q <= {WIDTH{1'b0}};
        end else begin
            q <= d;
        end
    end
endmodule

module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Shared reset buffer
    wire reset_buf;
    BUFX1 reset_buffer (.A(resetn), .Y(reset_buf));

    // Instantiate byte registers with clock gating
    ByteRegister #(8) upper_byte (
        .clk(clk),
        .resetn(reset_buf),
        .enable(byteena[1]),
        .d(d[15:8]),
        .q(q[15:8])
    );

    ByteRegister #(8) lower_byte (
        .clk(clk),
        .resetn(reset_buf),
        .enable(byteena[0]),
        .d(d[7:0]),
        .q(q[7:0])
    );

endmodule