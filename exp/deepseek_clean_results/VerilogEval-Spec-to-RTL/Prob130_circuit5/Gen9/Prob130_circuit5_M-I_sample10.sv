module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Determine if c is in valid range (0-3)
wire valid_sel = ~|c[3:2];  // c <4 when upper bits are 0

// Mux selection - use c[1:0] when valid, else don't care
wire [1:0] sel = valid_sel ? c[1:0] : 2'b00;

// 4:1 mux for valid selections
reg [3:0] mux_out;
always @(*) begin
    case (sel)
        2'b00: mux_out = b;
        2'b01: mux_out = e;
        2'b10: mux_out = a;
        2'b11: mux_out = d;
    endcase
end

// Final output - mux result when valid, 'f' otherwise
assign q = valid_sel ? mux_out : 4'b1111;

endmodule