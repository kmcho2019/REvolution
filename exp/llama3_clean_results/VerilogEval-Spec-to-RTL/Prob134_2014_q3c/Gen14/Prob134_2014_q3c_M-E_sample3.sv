module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// ROM for next state values
reg [2:0] next_state_rom [8];
initial begin
    next_state_rom[0] = (x == 0) ? 3'b000 : 3'b001;
    next_state_rom[1] = (x == 0) ? 3'b001 : 3'b100;
    next_state_rom[2] = (x == 0) ? 3'b010 : 3'b001;
    next_state_rom[3] = (x == 0) ? 3'b001 : 3'b010;
    next_state_rom[4] = (x == 0) ? 3'b011 : 3'b100;
    next_state_rom[5] = (x == 0) ? 3'b100 : 3'b100;
    next_state_rom[6] = (x == 0) ? 3'b011 : 3'b100;
    next_state_rom[7] = (x == 0) ? 3'b100 : 3'b100;
end

// ROM for output values
reg [0:0] output_rom [8];
initial begin
    output_rom[0] = 1'b0;
    output_rom[1] = 1'b0;
    output_rom[2] = 1'b0;
    output_rom[3] = 1'b1;
    output_rom[4] = 1'b1;
    output_rom[5] = 1'b0;
    output_rom[6] = 1'b1;
    output_rom[7] = 1'b1;
end

// Combinational logic for next state
always @ (*) begin
    case (y)
        3'b000: next_state = next_state_rom[0];
        3'b001: next_state = next_state_rom[1];
        3'b010: next_state = next_state_rom[2];
        3'b011: next_state = next_state_rom[3];
        3'b100: next_state = next_state_rom[4];
        default: next_state = 3'b000;
    endcase
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Output logic
always @ (*) begin
    case (y)
        3'b000, 3'b001, 3'b010: z = output_rom[0];
        3'b011, 3'b100: z = output_rom[3];
        default: z = output_rom[0];
    endcase
end

assign Y0 = next_state[0];

endmodule