module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Lookup table for next state
reg [2:0] next_state_lut [8];
initial begin
    next_state_lut[0] = (x)? 3'b001 : 3'b000; // S000
    next_state_lut[1] = (x)? 3'b100 : 3'b001; // S001
    next_state_lut[2] = (x)? 3'b001 : 3'b010; // S010
    next_state_lut[3] = (x)? 3'b010 : 3'b001; // S011
    next_state_lut[4] = (x)? 3'b100 : 3'b011; // S100
    next_state_lut[5] = (x)? 3'b001 : 3'b010; // S011 (not used)
    next_state_lut[6] = (x)? 3'b100 : 3'b100; // S100 (not used)
    next_state_lut[7] = (x)? 3'b000 : 3'b000; // (not used)
end

// Lookup table for output
reg [0:0] output_lut [8];
initial begin
    output_lut[0] = 1'b0; // S000
    output_lut[1] = 1'b0; // S001
    output_lut[2] = 1'b0; // S010
    output_lut[3] = 1'b1; // S011
    output_lut[4] = 1'b1; // S100
    output_lut[5] = 1'b0; // (not used)
    output_lut[6] = 1'b1; // (not used)
    output_lut[7] = 1'b0; // (not used)
end

// Combinational logic for next state
always @ (*) begin
    case (current_state)
        3'b000: next_state = next_state_lut[0];
        3'b001: next_state = next_state_lut[1];
        3'b010: next_state = next_state_lut[2];
        3'b011: next_state = next_state_lut[3];
        3'b100: next_state = next_state_lut[4];
        default: next_state = 3'b000;
    endcase
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Output logic
always @ (*) begin
    case (current_state)
        3'b000: z = output_lut[0];
        3'b001: z = output_lut[1];
        3'b010: z = output_lut[2];
        3'b011: z = output_lut[3];
        3'b100: z = output_lut[4];
        default: z = 1'b0;
    endcase
end

assign Y0 = next_state[0];

endmodule