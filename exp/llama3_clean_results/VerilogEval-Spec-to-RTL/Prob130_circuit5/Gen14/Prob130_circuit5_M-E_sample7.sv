module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

// Define the inputs to the multiplexer
wire [3:0] mux_inputs[0:3];
assign mux_inputs[0] = b;
assign mux_inputs[1] = e;
assign mux_inputs[2] = a;
assign mux_inputs[3] = d;

// Define the select lines for the multiplexer
wire [1:0] select_lines;
assign select_lines = c[1:0];

// Use a case statement to handle the default case (c > 3)
always @(*) begin
    case (select_lines)
        2'b00: q = mux_inputs[0]; // c == 0
        2'b01: q = mux_inputs[1]; // c == 1
        2'b10: q = mux_inputs[2]; // c == 2
        2'b11: q = mux_inputs[3]; // c == 3
        default: q = 4'd15; // c > 3
    endcase
end

endmodule