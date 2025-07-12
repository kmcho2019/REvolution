module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define the output z based on the current state
always @(*) begin
    case (current_state)
        3'b000: z = 1'b0;
        3'b001: z = 1'b0;
        3'b010: z = 1'b0;
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0; // default output for undefined states
    endcase
end

// Determine the next state based on the current state and input x
always @(*) begin
    case (current_state)
        3'b000: next_state = (x == 1'b0)? 3'b000 : 3'b001;
        3'b001: next_state = (x == 1'b0)? 3'b001 : 3'b100;
        3'b010: next_state = (x == 1'b0)? 3'b010 : 3'b001;
        3'b011: next_state = (x == 1'b0)? 3'b001 : 3'b010;
        3'b100: next_state = (x == 1'b0)? 3'b011 : 3'b100;
        default: next_state = 3'b000; // default next state for undefined states
    endcase
end

// Update the current state on the positive edge of the clock with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        current_state <= 3'b000;
    end else begin
        current_state <= next_state;
    end
end

endmodule