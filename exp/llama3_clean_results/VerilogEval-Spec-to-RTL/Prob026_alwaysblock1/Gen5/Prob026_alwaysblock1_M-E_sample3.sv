module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Define a lookup table (LUT) for the AND operation
wire [1:0] lut_input;
assign lut_input = {a, b};
wire lut_out;
assign lut_out = (lut_input == 2'b11)? 1'b1 : 1'b0;

assign out_assign = lut_out;

reg [1:0] state;
initial state = 2'b00;

always @(*) begin
    case(state)
        2'b00: if (a & b) out_alwaysblock = 1'b1; else out_alwaysblock = 1'b0;
        2'b01: out_alwaysblock = 1'b0;
        2'b10: out_alwaysblock = 1'b1;
        2'b11: out_alwaysblock = 1'b0;
    endcase
end

always @(posedge a or posedge b) begin
    state <= state + 1;
end

endmodule