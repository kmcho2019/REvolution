module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // Using a 2-bit register to store the current state (A or B)
reg [1:0] nextState; // Temporary register to store the next state

// Look-Up Table (LUT) to store next state and output values
reg [1:0] lutState [1:0];
reg [0:0] lutOutput [1:0];

initial begin
    // Initialize the LUT with correct next state and output values
    lutState[1'b0] = 1'b0; // State A, x=0, next state A
    lutState[1'b1] = 1'b1; // State A, x=1, next state B
    lutOutput[1'b0] = 1'b0; // State A, x=0, output 0
    lutOutput[1'b1] = 1'b1; // State A, x=1, output 1
    lutState[2'b10] = 2'b10; // State B, x=0, next state B
    lutState[2'b11] = 2'b10; // State B, x=1, next state B
    lutOutput[2'b10] = 1'b1; // State B, x=0, output 1
    lutOutput[2'b11] = 1'b0; // State B, x=1, output 0
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        // Use the current state and input 'x' to access the LUT
        case({state, x})
            2'b00: begin
                state <= lutState[1'b0];
                z <= lutOutput[1'b0];
            end
            2'b01: begin
                state <= lutState[1'b1];
                z <= lutOutput[1'b1];
            end
            2'b10: begin
                state <= lutState[2'b10];
                z <= lutOutput[2'b10];
            end
            2'b11: begin
                state <= lutState[2'b11];
                z <= lutOutput[2'b11];
            end
        endcase
    end
end

endmodule