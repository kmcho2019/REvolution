module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State decoding
wire is_A = (state == 2'b00);
wire is_B = (state == 2'b01);
wire is_C = (state == 2'b10);
wire is_D = (state == 2'b11);

// Next state computation
wire [1:0] next_A = is_A ? (in ? 2'b01 : 2'b00) : 2'b00;
wire [1:0] next_B = is_B ? (in ? 2'b01 : 2'b10) : 2'b00;
wire [1:0] next_C = is_C ? (in ? 2'b11 : 2'b00) : 2'b00;
wire [1:0] next_D = is_D ? (in ? 2'b01 : 2'b10) : 2'b00;

assign next_state = next_A | next_B | next_C | next_D;

// Output logic
assign out = is_D;

endmodule