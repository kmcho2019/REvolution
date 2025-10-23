module TopModule(
    input  clk,
    input  reset,
    input  x,
    output reg z
);

reg [2:0] current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 3'b000; // synchronous active high reset
    end else begin
        case (current_state)
            3'b000: current_state <= (x == 1'b0)? 3'b000 : 3'b001;
            3'b001: current_state <= (x == 1'b0)? 3'b001 : 3'b100;
            3'b010: current_state <= (x == 1'b0)? 3'b010 : 3'b001;
            3'b011: current_state <= (x == 1'b0)? 3'b001 : 3'b010;
            3'b100: current_state <= (x == 1'b0)? 3'b011 : 3'b100;
            default: current_state <= 3'b000; // default state
        endcase
    end
end

always @(*) begin
    case (current_state)
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule