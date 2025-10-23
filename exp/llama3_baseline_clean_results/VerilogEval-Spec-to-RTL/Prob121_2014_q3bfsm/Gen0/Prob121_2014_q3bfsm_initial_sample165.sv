module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // state variable
reg [2:0] next_y; // next state variable
reg z_reg; // output register

// state transition logic
always @(*) begin
    case (y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = 3'b000;
    endcase
end

// output logic
always @(*) begin
    case (y)
        3'b011: z_reg = 1'b1;
        3'b100: z_reg = 1'b1;
        default: z_reg = 1'b0;
    endcase
end

// sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
        z_reg <= 1'b0;
    end else begin
        y <= next_y;
        z_reg <= z_reg; // z_reg is combinatorial
    end
end

assign z = z_reg;

endmodule