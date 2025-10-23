module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using binary encoding
localparam STATE_A = 2'b00;
localparam STATE_B = 2'b01;
localparam STATE_C = 2'b10;
localparam STATE_D = 2'b11;

// Define the LUT for next state and output z
reg [1:0] currentState, nextState;
reg [1:0] lut_nextState [2:0];
reg lut_z [2:0];

initial begin
    lut_nextState[0] = STATE_B; // A, w = 0
    lut_nextState[1] = STATE_A; // A, w = 1
    lut_nextState[2] = STATE_C; // B, w = 0
    lut_nextState[3] = STATE_D; // B, w = 1
    lut_nextState[4] = STATE_E; // C, w = 0
    lut_nextState[5] = STATE_D; // C, w = 1
    lut_nextState[6] = STATE_F; // D, w = 0
    lut_nextState[7] = STATE_A; // D, w = 1
    lut_z[0] = 0; // A
    lut_z[1] = 0; // B
    lut_z[2] = 0; // C
    lut_z[3] = 0; // D
    lut_z[4] = 1; // E
    lut_z[5] = 1; // F
end

// Define the state E and F
localparam STATE_E = 2'b100;
localparam STATE_F = 2'b101;

// Stage 1: Current state and input
always @(posedge clk) begin
    if (reset) begin
        currentState <= STATE_A;
    end else begin
        currentState <= nextState;
    end
end

// Stage 2: Next state calculation and output z
always @(posedge clk) begin
    case (currentState)
        STATE_A: begin
            if (w) begin
                nextState <= STATE_A;
            end else begin
                nextState <= STATE_B;
            end
            z <= 0;
        end
        STATE_B: begin
            if (w) begin
                nextState <= STATE_D;
            end else begin
                nextState <= STATE_C;
            end
            z <= 0;
        end
        STATE_C: begin
            if (w) begin
                nextState <= STATE_D;
            end else begin
                nextState <= STATE_E;
            end
            z <= 0;
        end
        STATE_D: begin
            if (w) begin
                nextState <= STATE_A;
            end else begin
                nextState <= STATE_F;
            end
            z <= 0;
        end
        STATE_E: begin
            if (w) begin
                nextState <= STATE_D;
            end else begin
                nextState <= STATE_E;
            end
            z <= 1;
        end
        STATE_F: begin
            if (w) begin
                nextState <= STATE_D;
            end else begin
                nextState <= STATE_C;
            end
            z <= 1;
        end
    endcase
end

endmodule