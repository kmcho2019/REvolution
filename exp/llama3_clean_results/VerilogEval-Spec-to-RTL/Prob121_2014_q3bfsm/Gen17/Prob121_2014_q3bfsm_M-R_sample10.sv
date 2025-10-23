module TopModule(
    input  clk,
    input  reset,
    input  x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// Next state logic using assign for combinational logic
always @(*) begin
    case (y)
        3'b000: next_y = x? 3'b001 : 3'b000;
        3'b001: next_y = x? 3'b100 : 3'b001;
        3'b010: next_y = x? 3'b001 : 3'b010;
        3'b011: next_y = x? 3'b010 : 3'b001;
        3'b100: next_y = x? 3'b100 : 3'b011;
        default: next_y = 3'b000;
    endcase
end

// Output logic using assign for combinational logic
assign z = (y == 3'b011) || (y == 3'b100);

// Clock enable logic
reg clk_en;
always @(*) begin
    clk_en = (y != next_y);
end

// State register with clock enable
always @(posedge clk) begin
    if (reset || clk_en) begin
        if (reset) begin
            y <= 3'b000; // synchronous active high reset
        end else begin
            y <= next_y;
        end
    end
end

endmodule