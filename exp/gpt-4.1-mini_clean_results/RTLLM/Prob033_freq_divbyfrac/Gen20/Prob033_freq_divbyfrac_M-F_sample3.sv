module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counter cycles through 0 to 6 (7 states)
    reg [2:0] count;

    // Synchronous counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == 3'd6)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_div_pos is high for counts 0..3 (4 cycles)
    wire clk_div_pos = (count <= 3'd3);

    // Calculate next count value modulo 7
    wire [2:0] count_next = (count == 3'd6) ? 3'd0 : count + 3'd1;

    // clk_div_neg is high for counts 0..2 (3 cycles) shifted half cycle
    wire clk_div_neg = (count_next <= 3'd2);

    // Use clk as selector: clk_div follows clk_div_pos on clk posedge and clk_div_neg on clk negedge
    // This produces the fractional division clock with balanced duty cycle
    assign clk_div = clk ? clk_div_pos : clk_div_neg;

endmodule