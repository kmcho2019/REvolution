module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer DIV_MUL = 7;

    reg [2:0] count;
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

    // clk_int_a: high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
    wire clk_int_a = (count < 4);

    // clk_int_b: delayed inversion of clk_int_a by one clock cycle
    always @(posedge clk) begin
        if (!rst_n)
            clk_int_b <= 1'b0;
        else
            clk_int_b <= ~clk_int_a;
    end

    // Final output is OR of clk_int_a and clk_int_b
    assign clk_div = clk_int_a | clk_int_b;

endmodule