module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    // Parameter for reset value (all zeros)
    localparam [3:0] RESET_VALUE = 4'b0000;

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (~resetn)
            shift_reg <= RESET_VALUE;
        else
            shift_reg <= {shift_reg[2:0], in};
    end

    assign out = shift_reg[3];
endmodule