module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

// Define the states
parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

// State register
reg [2:0] y;
reg [2:0] next_y;

// Output
reg z_reg;

// Next state logic
always @(y, x) begin
    case (y)
        S000: next_y = (x == 1'b0) ? S000 : S001;
        S001: next_y = (x == 1'b0) ? S001 : S100;
        S010: next_y = (x == 1'b0) ? S010 : S001;
        S011: next_y = (x == 1'b0) ? S001 : S010;
        S100: next_y = (x == 1'b0) ? S011 : S100;
        default: next_y = S000; // default state
    endcase
end

// Output logic
always @(y) begin
    case (y)
        S000, S001, S010: z_reg = 1'b0;
        S011, S100: z_reg = 1'b1;
        default: z_reg = 1'b0; // default output
    endcase
end

// Update state register on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        y <= S000;
    end else begin
        y <= next_y;
    end
    z <= z_reg;
end

endmodule