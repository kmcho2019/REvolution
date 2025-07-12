module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output wire [7:0] out
);

    reg [7:0] out_reg;

    // On reset, initialize to 8'b0000_0001; on each clock, rotate the '1' bit left by 1
    always @(posedge clk or posedge reset) begin
        if (reset)
            out_reg <= 8'b0000_0001;
        else
            out_reg <= {out_reg[6:0], out_reg[7]};
    end

    // Continuous assignment to output
    assign out = out_reg;

endmodule