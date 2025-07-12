module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;
parameter S101 = 3'b101;
parameter S110 = 3'b110;
parameter S111 = 3'b111;

reg [2:0] y;
reg [2:0] next_y;

always @(posedge clk) begin
    if(reset) begin
        y <= S000;
    end else begin
        y <= next_y;
    end
end

always @(*) begin
    case(y)
        S000: next_y = (x == 1'b0) ? S000 : S001;
        S001: next_y = (x == 1'b0) ? S001 : S100;
        S010: next_y = (x == 1'b0) ? S010 : S001;
        S011: next_y = (x == 1'b0) ? S001 : S010;
        S100: next_y = (x == 1'b0) ? S011 : S100;
        default: next_y = S000;
    endcase
end

always @(*) begin
    case(y)
        S000: z = 1'b0;
        S001: z = 1'b0;
        S010: z = 1'b0;
        S011: z = 1'b1;
        S100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule