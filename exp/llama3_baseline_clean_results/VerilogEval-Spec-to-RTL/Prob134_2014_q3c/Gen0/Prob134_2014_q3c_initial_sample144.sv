module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;

always @(posedge clk) begin
    case (current_state)
        3'b000: current_state <= (x == 0) ? 3'b000 : 3'b001;
        3'b001: current_state <= (x == 0) ? 3'b001 : 3'b100;
        3'b010: current_state <= (x == 0) ? 3'b010 : 3'b001;
        3'b011: current_state <= (x == 0) ? 3'b001 : 3'b010;
        3'b100: current_state <= (x == 0) ? 3'b011 : 3'b100;
        default: current_state <= 3'b000;
    endcase
end

always @(*) begin
    case (current_state)
        3'b011: z <= 1;
        3'b100: z <= 1;
        default: z <= 0;
    endcase
end

assign Y0 = current_state[0];

endmodule