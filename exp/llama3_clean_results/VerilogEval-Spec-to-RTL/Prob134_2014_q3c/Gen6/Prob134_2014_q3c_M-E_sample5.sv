module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] state;
reg [2:0] nextState;

// Define the next state and output values for each combination of current state and input
reg [2:0] lut_state [8];
reg [2:0] lut_next_state [8];
reg [0:0] lut_z [8];

initial begin
    lut_state[0] = 3'b000;
    lut_state[1] = 3'b000;
    lut_state[2] = 3'b001;
    lut_state[3] = 3'b001;
    lut_state[4] = 3'b010;
    lut_state[5] = 3'b010;
    lut_state[6] = 3'b011;
    lut_state[7] = 3'b011;

    lut_next_state[0] = 3'b000; // S000, x = 0
    lut_next_state[1] = 3'b001; // S000, x = 1
    lut_next_state[2] = 3'b001; // S001, x = 0
    lut_next_state[3] = 3'b100; // S001, x = 1
    lut_next_state[4] = 3'b010; // S010, x = 0
    lut_next_state[5] = 3'b001; // S010, x = 1
    lut_next_state[6] = 3'b001; // S011, x = 0
    lut_next_state[7] = 3'b010; // S011, x = 1

    lut_z[0] = 1'b0; // S000, x = 0
    lut_z[1] = 1'b0; // S000, x = 1
    lut_z[2] = 1'b0; // S001, x = 0
    lut_z[3] = 1'b0; // S001, x = 1
    lut_z[4] = 1'b0; // S010, x = 0
    lut_z[5] = 1'b0; // S010, x = 1
    lut_z[6] = 1'b1; // S011, x = 0
    lut_z[7] = 1'b1; // S011, x = 1
end

// Combinational logic to determine next state and output z
always @(*) begin
    reg [2:0] index;
    index = {state, x};

    case (index)
        3'b000: begin
            nextState = lut_next_state[0];
            z = lut_z[0];
        end
        3'b001: begin
            nextState = lut_next_state[1];
            z = lut_z[1];
        end
        3'b010: begin
            nextState = lut_next_state[2];
            z = lut_z[2];
        end
        3'b011: begin
            nextState = lut_next_state[3];
            z = lut_z[3];
        end
        3'b100: begin
            nextState = lut_next_state[4];
            z = lut_z[4];
        end
        3'b101: begin
            nextState = lut_next_state[5];
            z = lut_z[5];
        end
        3'b110: begin
            nextState = lut_next_state[6];
            z = lut_z[6];
        end
        3'b111: begin
            nextState = lut_next_state[7];
            z = lut_z[7];
        end
    endcase
end

// Sequential logic to update current state
always @(posedge clk) begin
    state <= nextState;
end

// Continuous assignment to assign Y0
assign Y0 = nextState[0];

// Initialize state
initial begin
    state = 3'b000;
end

endmodule