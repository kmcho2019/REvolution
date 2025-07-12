module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define states for clarity
parameter S000 = 3'b000,
          S001 = 3'b001,
          S010 = 3'b010,
          S011 = 3'b011,
          S100 = 3'b100;

// Current state register
reg [2:0] currentState;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= S000; // Synchronous reset to state 000
    end else begin
        case (currentState)
            S000: currentState <= (x == 1'b0)? S000 : S001;
            S001: currentState <= (x == 1'b0)? S001 : S100;
            S010: currentState <= (x == 1'b0)? S010 : S001;
            S011: currentState <= (x == 1'b0)? S001 : S010;
            S100: currentState <= (x == 1'b0)? S011 : S100;
            default: currentState <= S000; // Default state
        endcase
    end
end

// Output logic
always @(currentState) begin
    case (currentState)
        S000, S001, S010, S100: z <= 1'b0;
        S011: z <= 1'b1;
        default: z <= 1'b0; // Default output
    endcase
end

endmodule