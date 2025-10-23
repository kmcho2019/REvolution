module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer DIV_MUL = 7;

    reg [2:0] count;
    reg       clk_int_a;
    reg       clk_int_b;

    // Counter increments on posedge clk, cycles 0..6
    always @(posedge clk) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == DIV_MUL - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // Generate clk_int_a: high for counts 0..3 (4 cycles), low otherwise
    always @(posedge clk) begin
        if (!rst_n)
            clk_int_a <= 1'b0;
        else
            clk_int_a <= (count < 4);
    end

    // Generate clk_int_b on negedge clk to achieve half-cycle phase shift
    // clk_int_b tracks clk_int_a delayed by half a clk period
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_int_b <= 1'b0;
        else
            clk_int_b <= clk_int_a;
    end

    // Final fractional divided clock is OR of clk_int_a and clk_int_b
    assign clk_div = clk_int_a | clk_int_b;

endmodule