module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input enable,           // Byte-level enable
    input [WIDTH-1:0] d,
    input [WIDTH-1:0] biten, // Per-bit enable within byte
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (!resetn) begin
            q <= {WIDTH{1'b0}};
        end else if (enable) begin
            for (integer i = 0; i < WIDTH; i = i + 1) begin
                if (biten[i]) q[i] <= d[i];
            end
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

    // Upper byte (bits 15:8) - all bits enabled when byteena[1] is high
    ByteRegister #(.WIDTH(8)) upper_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[1]),
        .biten(8'hFF),      // All bits enabled when byte is enabled
        .d(d[15:8]),
        .q(q[15:8])
    );

    // Lower byte (bits 7:0) - all bits enabled when byteena[0] is high
    ByteRegister #(.WIDTH(8)) lower_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[0]),
        .biten(8'hFF),      // All bits enabled when byte is enabled
        .d(d[7:0]),
        .q(q[7:0])
    );

endmodule