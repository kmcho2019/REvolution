module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

parameter NUM_STATES = 8;
parameter NUM_INPUTS = 3;

reg [2:0] currentState;
reg [2:0] nextState;
reg Y0_reg;
reg z_reg;

// Lookup Table (LUT) for next state and output
reg [2:0] lutNextState [NUM_STATES];
reg [0:0] lutOutput [NUM_STATES];

// Initialize LUT values
initial begin
    lutNextState[0] = 3'b000; // State 000, x=0
    lutNextState[1] = 3'b001; // State 000, x=1
    lutNextState[2] = 3'b001; // State 001, x=0
    lutNextState[3] = 3'b100; // State 001, x=1
    lutNextState[4] = 3'b010; // State 010, x=0
    lutNextState[5] = 3'b001; // State 010, x=1
    lutNextState[6] = 3'b001; // State 011, x=0
    lutNextState[7] = 3'b010; // State 011, x=1

    lutOutput[0] = 1'b0; // State 000, x=0
    lutOutput[1] = 1'b0; // State 000, x=1
    lutOutput[2] = 1'b0; // State 001, x=0
    lutOutput[3] = 1'b0; // State 001, x=1
    lutOutput[4] = 1'b0; // State 010, x=0
    lutOutput[5] = 1'b0; // State 010, x=1
    lutOutput[6] = 1'b1; // State 011, x=0
    lutOutput[7] = 1'b1; // State 011, x=1
end

// Compute next state and output
always @(*) begin
    case ({x, y})
        4'b0_000: begin
            nextState = lutNextState[0];
            z_reg = lutOutput[0];
        end
        4'b1_000: begin
            nextState = lutNextState[1];
            z_reg = lutOutput[1];
        end
        4'b0_001: begin
            nextState = lutNextState[2];
            z_reg = lutOutput[2];
        end
        4'b1_001: begin
            nextState = lutNextState[3];
            z_reg = lutOutput[3];
        end
        4'b0_010: begin
            nextState = lutNextState[4];
            z_reg = lutOutput[4];
        end
        4'b1_010: begin
            nextState = lutNextState[5];
            z_reg = lutOutput[5];
        end
        4'b0_011: begin
            nextState = lutNextState[6];
            z_reg = lutOutput[6];
        end
        4'b1_011: begin
            nextState = lutNextState[7];
            z_reg = lutOutput[7];
        end
        default: begin
            nextState = 3'b000;
            z_reg = 1'b0;
        end
    endcase
end

// Pipeline registers
always @(posedge clk) begin
    currentState <= y;
    Y0_reg <= nextState[0];
    z <= z_reg;
end

assign Y0 = Y0_reg;

endmodule