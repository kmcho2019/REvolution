module TopModule (
    input clk,
    input d,
    output reg q
);

reg prev_clk;

always @(posedge clk or negedge clk) begin
    if (prev_clk == 1'b0 && clk == 1'b1) begin // Rising edge
        q <= d;
    end else if (prev_clk == 1'b1 && clk == 1'b0) begin // Falling edge
        q <= d;
    end
    prev_clk <= clk;
end

endmodule