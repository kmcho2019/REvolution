module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] present_state;
reg [2:0] next_state;

always @ (posedge clk) begin
    present_state <= next_state;
end

always @ (*) begin
    case (present_state)
        3'b000: next_state = x ? 3'b001 : 3'b000;
        3'b001: next_state = x ? 3'b100 : 3'b001;
        3'b010: next_state = x ? 3'b001 : 3'b010;
        3'b011: next_state = x ? 3'b010 : 3'b001;
        3'b100: next_state = x ? 3'b100 : 3'b011;
        default: next_state = 3'b000;
    endcase
end

assign Y0 = next_state[0];

always @ (*) begin
    case (present_state)
        3'b000: z = 1'b0;
        3'b001: z = 1'b0;
        3'b010: z = 1'b0;
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule