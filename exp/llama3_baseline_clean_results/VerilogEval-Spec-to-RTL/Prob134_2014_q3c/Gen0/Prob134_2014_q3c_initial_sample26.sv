module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] y_state;
reg [2:0] y_next;

always @(*) begin
    case (y_state)
        3'b000: y_next = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: y_next = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: y_next = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: y_next = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: y_next = (x == 1'b0) ? 3'b011 : 3'b100;
        default: y_next = 3'b000;
    endcase
end

always @(*) begin
    case (y_state)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

always @(posedge clk) begin
    y_state <= y_next;
end

assign Y0 = y_next[0];

endmodule