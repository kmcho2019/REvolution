module TopModule (
    input  wire clk,
    input  wire resetn,  // active-low synchronous reset
    input  wire in,
    output wire out
);
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (~resetn)
            shift_reg <= 4'b0;
        else
            shift_reg <= {shift_reg[2:0], in};
    end

    assign out = shift_reg[3];
endmodule