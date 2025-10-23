module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state; // Current state
reg [3:0] nextState; // Next state in the Gray code sequence

// Define the Gray code sequence for the decade counter
localparam [3:0] grayCode[10] = {
    4'd0,  // 0000
    4'd1,  // 0001
    4'd3,  // 0011
    4'd2,  // 0010
    4'd6,  // 0110
    4'd7,  // 0111
    4'd5,  // 0101
    4'd4,  // 0100
    4'd12, // 1100
    4'd13  // 1101
};

// Function to get the next state in the Gray code sequence
function [3:0] getNextState;
    input [3:0] currentState;
    reg [3:0] nextState;

    for (int i = 0; i < 10; i++) begin
        if (grayCode[i] == currentState) begin
            if (i == 9) begin
                nextState = grayCode[0]; // Wrap around to the start
            end else begin
                nextState = grayCode[i + 1];
            end
            break;
        end
    end

    getNextState = nextState;
endfunction

always @(posedge clk) begin
    if (reset) begin
        state <= grayCode[0]; // Reset to the initial state
    end else begin
        nextState = getNextState(state);
        state <= nextState;
    end
end

assign q = state;

endmodule