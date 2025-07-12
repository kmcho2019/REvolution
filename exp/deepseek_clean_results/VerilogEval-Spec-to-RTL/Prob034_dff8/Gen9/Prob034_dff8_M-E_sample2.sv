module TopModule (
    input        clk,
    input  [7:0] d,
    output [7:0] q
);

parameter WIDTH = 8;
reg [WIDTH-1:0] shift_reg;
reg mode;  // 0 = normal, 1 = circular shift

initial begin
    mode = 0;  // Default to normal mode
    shift_reg = 0;
end

always @(posedge clk) begin
    if (mode) begin
        // Circular shift mode
        shift_reg <= {shift_reg[0], shift_reg[WIDTH-1:1]};
    end else begin
        // Normal register mode
        shift_reg <= d;
    end
end

assign q = shift_reg;

endmodule