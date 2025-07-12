module TopModule (
    output reg zero
);
    always @(posedge clk or posedge reset) begin
        if (reset) zero <= 1'b0;
        else zero <= 1'b0;
    end

    // Internal clock and reset generation
    wire clk, reset;
    ClockGen clock_gen(.clk(clk));
    ResetGen reset_gen(.rst(reset));
endmodule

module ClockGen(output reg clk);
    initial clk = 0;
    always #5 clk = ~clk;
endmodule

module ResetGen(output reg rst);
    initial begin
        rst = 1;
        #10 rst = 0;
    end
endmodule