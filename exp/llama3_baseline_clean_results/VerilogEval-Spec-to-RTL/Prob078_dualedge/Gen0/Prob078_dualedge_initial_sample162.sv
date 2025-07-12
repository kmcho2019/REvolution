module TopModule(clk, d, q);
    input clk;
    input d;
    output q;
    reg q;

    reg rising_flip_flop_q;
    reg falling_flip_flop_q;

    always @(posedge clk) begin
        rising_flip_flop_q <= d;
    end

    always @(negedge clk) begin
        falling_flip_flop_q <= d;
    end

    assign q = (clk == 1'b0) ? falling_flip_flop_q : rising_flip_flop_q;

endmodule