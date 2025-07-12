module TopModule(
    input  clk,
    input  reset,
    input  x,
    output reg z
);

// Define the states
parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

// Current state
reg [2:0] currentState;

// Combinational logic for next state
always @(*) begin
    case(currentState)
        S000: currentState <= (x == 0) ? S000 : S001;
        S001: currentState <= (x == 0) ? S001 : S100;
        S010: currentState <= (x == 0) ? S010 : S001;
        S011: currentState <= (x == 0) ? S001 : S010;
        S100: currentState <= (x == 0) ? S011 : S100;
        default: currentState <= S000;
    endcase
end

// Sequential logic for state update and output
always @(posedge clk) begin
    if (reset) begin
        currentState <= S000;
    end else begin
        // No need to assign next state, since currentState is updated in the combinational logic block
    end
    
    // Determine output z based on current state
    case(currentState)
        S000, S001, S010: z <= 0;
        S011, S100: z <= 1;
        default: z <= 0;
    endcase
end

endmodule