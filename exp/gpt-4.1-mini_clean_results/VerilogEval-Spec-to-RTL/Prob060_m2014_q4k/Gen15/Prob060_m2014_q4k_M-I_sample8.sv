module TopModule (
    input  wire clk,
    input  wire resetn,  // active-low synchronous reset
    input  wire in,
    output reg  out
);
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (~resetn)
            shift_reg <= 4'b0000;
        else
            shift_reg <= {shift_reg[2:0], in};
    end

    always @(posedge clk) begin
        out <= shift_reg[3];
    end
endmodule