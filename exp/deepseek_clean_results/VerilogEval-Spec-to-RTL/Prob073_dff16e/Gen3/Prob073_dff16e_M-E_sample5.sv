module ByteRegister #(parameter WIDTH = 8) (
    input clk,
    input clk_en,
    input resetn,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    wire gated_clk = clk & clk_en;
    
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
        .clk_en(byteena[1]),
        .resetn(resetn),
        .d(d[15:8]),
        .q(q[15:8])
    );
    
    // Lower byte (bits 7:0)
    ByteRegister #(8) lower_byte (
        .clk(clk),
        .clk_en(byteena[0]),
        .resetn(resetn),
        .d(d[7:0]),
        .q(q[7:0])
    );
endmodule