module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;

// Sequential logic and next state logic combined
always @ (posedge clk) begin
    case (y)
        3'b000: current_state <= (x)? 3'b001 : 3'b000;
        3'b001: current_state <= (x)? 3'b100 : 3'b001;
        3'b010: current_state <= (x)? 3'b001 : 3'b010;
        3'b011: current_state <= (x)? 3'b010 : 3'b001;
        3'b100: current_state <= (x)? 3'b100 : 3'b011;
        default: current_state <= 3'b000;
    endcase
end

// Output logic simplified
assign z = (y == 3'b011 || y == 3'b100) ? 1'b1 : 1'b0;
assign Y0 = current_state[0];

endmodule