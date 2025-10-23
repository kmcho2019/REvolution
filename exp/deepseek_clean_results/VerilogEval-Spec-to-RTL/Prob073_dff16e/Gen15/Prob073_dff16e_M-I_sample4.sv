module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    // Clock gating control
    wire gated_clk;
    CLK_GATE icg (
        .CK(clk),
        .E(enable),
        .ECK(gated_clk)
    );

    always @(posedge gated_clk or negedge resetn) begin
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

    // Upper byte (bits 15:8)
    ByteRegister #(8) upper_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[1]),
        .d(d[15:8]),
        .q(q[15:8])
    );

    // Lower byte (bits 7:0)
    ByteRegister #(8) lower_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[0]),
        .d(d[7:0]),
        .q(q[7:0])
    );

endmodule

// Standard clock gating cell
module CLK_GATE (
    input CK,
    input E,
    output ECK
);
    // This will be replaced by the technology-specific ICG cell during synthesis
    assign ECK = CK & E;
endmodule