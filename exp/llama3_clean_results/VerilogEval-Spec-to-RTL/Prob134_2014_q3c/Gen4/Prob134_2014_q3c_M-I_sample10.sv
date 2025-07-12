module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] state, nextState;
reg [2:0] lut_next_state [5][2]; // 2D LUT for next state
reg [0:0] lut_output [5][2]; // 2D LUT for output z

// Initialize LUT values
initial begin
    lut_next_state[0][0] = 3'b000; lut_output[0][0] = 1'b0;
    lut_next_state[0][1] = 3'b001; lut_output[0][1] = 1'b0;
    lut_next_state[1][0] = 3'b001; lut_output[1][0] = 1'b0;
    lut_next_state[1][1] = 3'b100; lut_output[1][1] = 1'b0;
    lut_next_state[2][0] = 3'b010; lut_output[2][0] = 1'b0;
    lut_next_state[2][1] = 3'b001; lut_output[2][1] = 1'b0;
    lut_next_state[3][0] = 3'b001; lut_output[3][0] = 1'b1;
    lut_next_state[3][1] = 3'b010; lut_output[3][1] = 1'b1;
    lut_next_state[4][0] = 3'b011; lut_output[4][0] = 1'b1;
    lut_next_state[4][1] = 3'b100; lut_output[4][1] = 1'b1;
end

// Combinational logic to determine next state and output z
always @(*) begin
    case (y)
        3'b000: begin
            nextState = lut_next_state[0][x];
            z = lut_output[0][x];
        end
        3'b001: begin
            nextState = lut_next_state[1][x];
            z = lut_output[1][x];
        end
        3'b010: begin
            nextState = lut_next_state[2][x];
            z = lut_output[2][x];
        end
        3'b011: begin
            nextState = lut_next_state[3][x];
            z = lut_output[3][x];
        end
        3'b100: begin
            nextState = lut_next_state[4][x];
            z = lut_output[4][x];
        end
    endcase
end

// Sequential logic to update current state
always @(posedge clk) begin
    state <= nextState;
end

// Continuous assignment to assign Y0
assign Y0 = nextState[0];

// Initialize state and nextState
initial begin
    state = 3'b000;
    nextState = 3'b000;
end

endmodule