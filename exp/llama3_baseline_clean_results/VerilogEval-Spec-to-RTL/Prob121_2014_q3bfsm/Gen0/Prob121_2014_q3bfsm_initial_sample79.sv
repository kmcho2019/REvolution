module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // current state
reg z_reg; // output register

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous reset
    end else begin
        case (y)
            3'b000: y <= (x) ? 3'b001 : 3'b000;
            3'b001: y <= (x) ? 3'b100 : 3'b001;
            3'b010: y <= (x) ? 3'b001 : 3'b010;
            3'b011: y <= (x) ? 3'b010 : 3'b001;
            3'b100: y <= (x) ? 3'b100 : 3'b011;
            default: y <= 3'b000; // default next state if current state not recognized
        endcase
    end
end

always @(posedge clk) begin
    case (y)
        3'b011, 3'b100: z_reg <= 1'b1;
        default: z_reg <= 1'b0;
    endcase
end

assign z = z_reg;

endmodule