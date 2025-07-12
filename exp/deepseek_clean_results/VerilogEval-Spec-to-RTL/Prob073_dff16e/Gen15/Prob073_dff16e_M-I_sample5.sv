module ByteRegister (
    input clk,
    input gated_clk,
    input resetn,
    input enable,
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge gated_clk or negedge resetn) begin
        if (!resetn) begin
            q <= 8'b0;
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

    // Clock gating cells
    wire upper_byte_clk;
    wire lower_byte_clk;

    CLK_GATE upper_clk_gate (
        .CLK(clk),
        .EN(byteena[1]),
        .GCLK(upper_byte_clk)
    );

    CLK_GATE lower_clk_gate (
        .CLK(clk),
        .EN(byteena[0]),
        .GCLK(lower_byte_clk)
    );

    // Upper byte (bits 15:8)
    ByteRegister upper_byte (
        .clk(clk),
        .gated_clk(upper_byte_clk),
        .resetn(resetn),
        .enable(1'b1),  // Enable handled by clock gating
        .d(d[15:8]),
        .q(q[15:8])
    );

    // Lower byte (bits 7:0)
    ByteRegister lower_byte (
        .clk(clk),
        .gated_clk(lower_byte_clk),
        .resetn(resetn),
        .enable(1'b1),  // Enable handled by clock gating
        .d(d[7:0]),
        .q(q[7:0])
    );

endmodule