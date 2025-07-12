module TopModule (
    input  clk,
    input  d,
    output reg q
);

    // Generate delayed version of clk by one cycle to produce doubled frequency clock
    reg clk_d1 = 0;
    always @(posedge clk or negedge clk) begin
        clk_d1 <= clk;
    end

    wire dbl_clk = clk ^ clk_d1;  // XOR produces pulses at both edges => double frequency clock

    reg d_dblclk;
    // Sample input 'd' at posedge of doubled frequency clock
    always @(posedge dbl_clk) begin
        d_dblclk <= d;
    end

    // Output q is updated at each posedge of doubled frequency clock
    always @(posedge dbl_clk) begin
        q <= d_dblclk;
    end

endmodule