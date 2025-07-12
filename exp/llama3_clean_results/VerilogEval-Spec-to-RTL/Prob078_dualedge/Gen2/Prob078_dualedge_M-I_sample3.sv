module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg prev_clk;

always @(posedge clk or negedge clk) begin
    if (clk == 1'b1 && prev_clk == 1'b0) begin // rising edge
        q <= d;
    end else if (clk == 1'b0 && prev_clk == 1'b1) begin // falling edge
        q <= d;
    end
    prev_clk <= clk;
end

endmodule