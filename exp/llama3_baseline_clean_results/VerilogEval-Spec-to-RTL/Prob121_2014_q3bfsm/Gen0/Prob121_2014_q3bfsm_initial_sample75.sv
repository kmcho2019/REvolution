module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y;
wire [2:0] next_y;

// Combinational logic for next state
always @(*)
begin
    case (y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = y; // default to current state for unspecified states
    endcase
end

// Sequential logic for current state
always @(posedge clk)
begin
    if (reset)
        y <= 3'b000; // synchronous active high reset
    else
        y <= next_y;
end

// Combinational logic for output z
always @(*)
begin
    case (y)
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule