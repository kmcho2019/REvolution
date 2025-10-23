module BitRegister (
    input clk,
    input resetn,
    input enable,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (!resetn) begin
            q <= 1'b0;
        end else if (enable) begin
            q <= d;
        end
    end
endmodule

module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input byte_enable,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_gen
            BitRegister bit_reg (
                .clk(clk),
                .resetn(resetn),
                .enable(byte_enable), // All bits in byte share enable
                .d(d[i]),
                .q(q[i])
            );
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
    // Upper byte register (bits 15:8)
    ByteRegister #(.WIDTH(8)) upper_byte (
        .clk(clk),
        .resetn(resetn),
        .byte_enable(byteena[1]),
        .d(d[15:8]),
        .q(q[15:8])
    );
    
    // Lower byte register (bits 7:0)
    ByteRegister #(.WIDTH(8)) lower_byte (
        .clk(clk),
        .resetn(resetn),
        .byte_enable(byteena[0]),
        .d(d[7:0]),
        .q(q[7:0])
    );
endmodule