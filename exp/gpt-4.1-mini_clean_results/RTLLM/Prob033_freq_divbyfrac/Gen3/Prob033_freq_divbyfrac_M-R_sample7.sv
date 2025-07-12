module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for division
    localparam integer DIV_MUL = 7;  // Counter modulus

    reg [2:0] count;          // 3-bit counter counting 0..6
    reg [2:0] count_negedge; // Counter sampled on negedge clk (phase shifted)

    // Synchronous counter increments on posedge clk
    always @(posedge clk) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == DIV_MUL - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // Sample the count at negedge clk to achieve half clock phase shift
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            count_negedge <= 3'd0;
        else
            count_negedge <= count;
    end

    // Generate intermediate clocks based on counts
    // clk_int_a: high for counts 0..3 (4 cycles), else low
    wire clk_int_a = (count < 4);

    // clk_int_b: high for counts 3..5 (3 cycles), else low (phase shifted)
    wire clk_int_b = (count_negedge >= 3) && (count_negedge <= 5);

    // Final fractional clock output is OR of the two intermediate clocks
    assign clk_div = clk_int_a | clk_int_b;

endmodule