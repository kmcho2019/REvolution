module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // current state
reg [2:0] next_state; // next state

// Determine the next state based on the current state and input x
always @(*) begin
    case (y)
        3'b000: next_state = x? 3'b001 : 3'b000;
        3'b001: next_state = x? 3'b100 : 3'b001;
        3'b010: next_state = x? 3'b001 : 3'b010;
        3'b011: next_state = x? 3'b010 : 3'b001;
        3'b100: next_state = x? 3'b100 : 3'b011;
        default: next_state = 3'b000; // default to state 000
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // reset to state 000
    end else begin
        y <= next_state;
    end
end

// Determine the output z based on the current state
always @(*) begin
    case (y)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0; // default output to 0
    endcase
end

endmodule