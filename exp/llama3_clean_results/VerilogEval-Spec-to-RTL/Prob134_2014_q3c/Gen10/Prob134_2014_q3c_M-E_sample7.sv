module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define the LUTs for next state and output
reg [2:0] next_state_lut [8];
reg [0:0] output_lut [8];

// Initialize the LUTs
initial begin
    next_state_lut[0] = 3'b000; // y = 000, x = 0
    next_state_lut[1] = 3'b001; // y = 000, x = 1
    next_state_lut[2] = 3'b001; // y = 001, x = 0
    next_state_lut[3] = 3'b100; // y = 001, x = 1
    next_state_lut[4] = 3'b010; // y = 010, x = 0
    next_state_lut[5] = 3'b001; // y = 010, x = 1
    next_state_lut[6] = 3'b001; // y = 011, x = 0
    next_state_lut[7] = 3'b010; // y = 011, x = 1
    output_lut[0] = 1'b0; // y = 000
    output_lut[1] = 1'b0; // y = 001
    output_lut[2] = 1'b0; // y = 010
    output_lut[3] = 1'b1; // y = 011
    output_lut[4] = 1'b1; // y = 100
end

// Combinational logic for next state and output
always @ (*) begin
    if (x) begin
        case (y)
            3'b000: next_state = 3'b001;
            3'b001: next_state = 3'b100;
            3'b010: next_state = 3'b001;
            3'b011: next_state = 3'b010;
            3'b100: next_state = 3'b100;
            default: next_state = 3'b000;
        endcase
    end else begin
        case (y)
            3'b000: next_state = 3'b000;
            3'b001: next_state = 3'b001;
            3'b010: next_state = 3'b010;
            3'b011: next_state = 3'b001;
            3'b100: next_state = 3'b011;
            default: next_state = 3'b000;
        endcase
    end
    
    // Read output from LUT
    case (y)
        3'b000: z = 1'b0;
        3'b001: z = 1'b0;
        3'b010: z = 1'b0;
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

assign Y0 = next_state[0];

endmodule