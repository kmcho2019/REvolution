module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state
reg z_reg; // output register

always @(*) begin
    case (y)
        3'b000: next_y = x? 3'b001 : 3'b000;
        3'b001: next_y = x? 3'b100 : 3'b001;
        3'b010: next_y = x? 3'b001 : 3'b010;
        3'b011: next_y = x? 3'b010 : 3'b001;
        3'b100: next_y = x? 3'b100 : 3'b011;
        default: next_y = 3'b000; // default next state
    endcase

    case (y)
        3'b000: z_reg = 1'b0;
        3'b001: z_reg = 1'b0;
        3'b010: z_reg = 1'b0;
        3'b011: z_reg = 1'b1;
        3'b100: z_reg = 1'b1;
        default: z_reg = 1'b0; // default output
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
        z <= 1'b0;
    end else begin
        y <= next_y;
        z <= z_reg;
    end
end

assign z = z;

endmodule