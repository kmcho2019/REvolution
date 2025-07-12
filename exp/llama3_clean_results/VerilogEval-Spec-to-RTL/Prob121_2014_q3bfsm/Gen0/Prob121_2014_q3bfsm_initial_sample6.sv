module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y, next_y;

// State transition logic
always @(*) begin
    case (y)
        3'b000: next_y = (x) ? 3'b001 : 3'b000;
        3'b001: next_y = (x) ? 3'b100 : 3'b001;
        3'b010: next_y = (x) ? 3'b001 : 3'b010;
        3'b011: next_y = (x) ? 3'b010 : 3'b001;
        3'b100: next_y = (x) ? 3'b100 : 3'b011;
        default: next_y = 3'b000;
    endcase
end

// Output logic
always @(*) begin
    case (y)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011, 3'b100: z = 1;
        default: z = 0;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        y <= next_y;
    end
end

endmodule