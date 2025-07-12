module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state

// Combinational logic for next state and output
always @(*) begin
    case (y)
        3'b000: next_y = (x == 1'b0)? 3'b000 : 3'b001;
        3'b001: next_y = (x == 1'b0)? 3'b001 : 3'b100;
        3'b010: next_y = (x == 1'b0)? 3'b010 : 3'b001;
        3'b011: next_y = (x == 1'b0)? 3'b001 : 3'b010;
        3'b100: next_y = (x == 1'b0)? 3'b011 : 3'b100;
        default: next_y = 3'b000; // Default to initial state if not matched
    endcase
    
    // Output logic
    case (y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Reset to initial state on positive edge of clock when reset is high
    end else begin
        y <= next_y; // Update state on each positive clock edge
    end
end

endmodule