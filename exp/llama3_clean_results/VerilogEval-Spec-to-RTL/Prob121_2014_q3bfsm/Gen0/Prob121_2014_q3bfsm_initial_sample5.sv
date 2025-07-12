module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

reg [2:0] y;
reg [2:0] next_y;
wire z_w;

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        case (y)
            3'b000: next_y = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_y = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_y = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_y = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_y = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_y = 3'b000; // default case
        endcase
        y <= next_y;
    end
end

always @(y) begin
    case (y)
        3'b000: z_w = 1'b0;
        3'b001: z_w = 1'b0;
        3'b010: z_w = 1'b0;
        3'b011: z_w = 1'b1;
        3'b100: z_w = 1'b1;
        default: z_w = 1'b0; // default case
    endcase
end

assign z = z_w;

endmodule