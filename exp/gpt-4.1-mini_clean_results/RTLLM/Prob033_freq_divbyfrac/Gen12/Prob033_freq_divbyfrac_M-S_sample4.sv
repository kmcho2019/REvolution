module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_MOD = 7;

    reg [2:0] counter;
    reg       clk_intA;
    reg       clk_intB;

    // Counter and clk_intA generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter  <= 3'd0;
            clk_intA <= 1'b0;
        end else begin
            if (counter == DIV_MOD - 1)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;

            // clk_intA high for 4 cycles, low for 3 cycles
            clk_intA <= (counter < 4) ? 1'b1 : 1'b0;
        end
    end

    // clk_intB is clk_intA delayed by one clock cycle to create phase shift
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_intB <= 1'b0;
        end else begin
            clk_intB <= clk_intA;
        end
    end

    // Final output: OR of clk_intA and clk_intB
    assign clk_div = clk_intA | clk_intB;

endmodule