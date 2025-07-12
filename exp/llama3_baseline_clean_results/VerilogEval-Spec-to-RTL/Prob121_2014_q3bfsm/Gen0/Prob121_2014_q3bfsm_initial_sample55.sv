module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define the states as parameters
parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

// Declare the current and next state variables
reg [2:0] currentState, nextState;

// Sequential logic to update the current state
always @(posedge clk) begin
    if (reset) begin
        currentState <= S000;
    end else begin
        currentState <= nextState;
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (currentState)
        S000: nextState = x ? S001 : S000;
        S001: nextState = x ? S100 : S001;
        S010: nextState = x ? S001 : S010;
        S011: nextState = x ? S010 : S001;
        S100: nextState = x ? S100 : S011;
        default: nextState = S000; // default to S000 if currentState is unknown
    endcase
end

// Combinational logic to determine the output 'z'
always @(*) begin
    case (currentState)
        S011, S100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule