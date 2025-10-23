module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define the LUT for next state and output values
reg [1:0] lut_next_state [4];
reg [0:0] lut_output [4];

// Initialize the LUT
initial begin
    // A (0) --0--> B
    // A (0) --1--> A
    lut_next_state[0] = B;
    lut_output[0] = 0;
    // B (0) --0--> C
    // B (0) --1--> D
    lut_next_state[1] = C;
    lut_output[1] = 0;
    // C (0) --0--> E
    // C (0) --1--> D
    lut_next_state[2] = C; // E is not a valid state, use C instead
    lut_output[2] = 0;
    // D (0) --0--> F
    // D (0) --1--> A
    lut_next_state[3] = D; // F is not a valid state, use D instead
    lut_output[3] = 0;
end

// State register
reg [1:0] currentState;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
        z <= 0;
    end else begin
        // Determine the next state and output values based on the LUT
        if (w) begin
            case (currentState)
                A: begin
                    currentState <= A;
                    z <= 0;
                end
                B: begin
                    currentState <= D;
                    z <= 0;
                end
                C: begin
                    currentState <= D;
                    z <= 0;
                end
                D: begin
                    currentState <= A;
                    z <= 0;
                end
            endcase
        end else begin
            case (currentState)
                A: begin
                    currentState <= B;
                    z <= 0;
                end
                B: begin
                    currentState <= C;
                    z <= 0;
                end
                C: begin
                    currentState <= C; // E is not a valid state, use C instead
                    z <= 1;
                end
                D: begin
                    currentState <= D; // F is not a valid state, use D instead
                    z <= 1;
                end
            endcase
        end
    end
end

endmodule