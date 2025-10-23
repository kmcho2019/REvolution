module TopModule (
    input  clk,
    input  d,
    output reg q
);

    wire clk_n;
    reg q_pos, q_neg;
    reg toggle; // to indicate which sample to output (rising or falling edge sample)

    // Generate inverted clock by using a small combinational inverter
    assign clk_n = ~clk;

    // Sample data on positive edge of clk
    always @(posedge clk) begin
        q_pos <= d;
        toggle <= 1'b1; // Indicate rising edge sample is current
    end

    // Sample data on positive edge of inverted clock (which is falling edge of clk)
    always @(posedge clk_n) begin
        q_neg <= d;
        toggle <= 1'b0; // Indicate falling edge sample is current
    end

    // Output toggles between q_pos and q_neg depending on which edge just occurred
    always @(*) begin
        if (toggle)
            q = q_pos;
        else
            q = q_neg;
    end

endmodule