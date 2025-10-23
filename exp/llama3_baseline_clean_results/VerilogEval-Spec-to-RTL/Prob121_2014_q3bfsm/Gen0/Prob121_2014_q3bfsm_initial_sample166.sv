module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state

// Combinational logic for next state
always @(*) begin
    case (y)
        3'b000: next_y = x? 3'b001 : 3'b000;
        3'b001: next_y = x? 3'b100 : 3'b001;
        3'b010: next_y = x? 3'b001 : 3'b010;
        3'b011: next_y = x? 3'b010 : 3'b001;
        3'b100: next_y = x? 3'b100 : 3'b011;
        default: next_y = 3'b000; // Default to state 000 for any other state
    endcase
end

// Sequential logic for state update and output z
always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        y <= 3'b000;
    end else begin
        y <= next_y;
    end
end

// Output z logic
always @(*) begin
    case (y)
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule