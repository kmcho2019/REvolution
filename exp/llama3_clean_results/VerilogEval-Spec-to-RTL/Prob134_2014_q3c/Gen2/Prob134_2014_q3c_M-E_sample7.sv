module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

// Define the initial state as a local parameter
localparam INITIAL_STATE = 3'b000;

reg [2:0] currentState; // Current state
reg [2:0] nextState;   // Next state

// Assign Y0 as the least significant bit of the next state
assign Y0 = nextState[0];

// Combinational logic to determine the next state and output z
always @(*) begin
    case (y)
        3'b000: begin
            nextState = x ? 3'b001 : 3'b000;
            z = 1'b0;
        end
        3'b001: begin
            nextState = x ? 3'b100 : 3'b001;
            z = 1'b0;
        end
        3'b010: begin
            nextState = x ? 3'b001 : 3'b010;
            z = 1'b0;
        end
        3'b011: begin
            nextState = x ? 3'b010 : 3'b001;
            z = 1'b1;
        end
        3'b100: begin
            nextState = x ? 3'b100 : 3'b011;
            z = 1'b1;
        end
    endcase
end

// Sequential logic to update the current state
always @(posedge clk) begin
    currentState <= nextState;
end

// Initialize the current state
initial begin
    currentState = INITIAL_STATE; // Initialize current state
    z = 1'b0; // Initialize output z
end

endmodule