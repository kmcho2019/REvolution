module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// LUT that maps c values to selector codes
reg [1:0] selector_lut [0:15];
initial begin
    selector_lut[0] = 2'b00;  // select b
    selector_lut[1] = 2'b01;  // select e
    selector_lut[2] = 2'b10;  // select a
    selector_lut[3] = 2'b11;  // select d
    // All other addresses default to forcing output high
    for (integer i = 4; i < 16; i = i + 1)
        selector_lut[i] = 2'bxx; // don't care (handled by default case)
end

wire [1:0] selector = selector_lut[c];
wire default_case = (c > 3);

// Input selection multiplexer
reg [3:0] selected_input;
always @(*) begin
    case (selector)
        2'b00: selected_input = b;
        2'b01: selected_input = e;
        2'b10: selected_input = a;
        2'b11: selected_input = d;
        default: selected_input = 4'b1111;
    endcase
end

// Final output with default case override
assign q = default_case ? 4'b1111 : selected_input;

endmodule