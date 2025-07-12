module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y;  // Current state
wire [2:0] next_y;  // Next state
reg z_reg;  // Output register

// Next state logic
always @(*) begin
    case(y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = 3'b000;  // Default state
    endcase
end

// Output logic
always @(*) begin
    case(y)
        3'b000: z_reg = 0;
        3'b001: z_reg = 0;
        3'b010: z_reg = 0;
        3'b011: z_reg = 1;
        3'b100: z_reg = 1;
        default: z_reg = 0;  // Default output
    endcase
end

// State register
always @(posedge clk) begin
    if(reset) begin
        y <= 3'b000;
    end else begin
        y <= next_y;
    end
end

// Output assignment
assign z = z_reg;

endmodule