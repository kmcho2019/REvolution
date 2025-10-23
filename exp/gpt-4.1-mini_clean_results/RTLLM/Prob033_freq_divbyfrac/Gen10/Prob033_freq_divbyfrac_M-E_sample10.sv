module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_MOD = 7;

    reg [2:0] counter;
    reg       clk_intA;
    reg       clk_intB;

    // Generate clk_intA: high for 4 cycles (counts 0..3), low for 3 cycles (4..6)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 3'd0;
            clk_intA <= 1'b0;
        end else begin
            if (counter == DIV_MOD - 1)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;

            // High for counts 0-3, low for counts 4-6
            if (counter < 4)
                clk_intA <= 1'b1;
            else
                clk_intA <= 1'b0;
        end
    end

    // clk_intB: half-cycle delayed version of clk_intA
    // Use clk inverted (clk_bar) to clock clk_intA into clk_intB, creating a half-cycle phase shift
    wire clk_bar = ~clk;
    reg  clk_intA_d;

    always @(posedge clk_bar or negedge rst_n) begin
        if (!rst_n) begin
            clk_intA_d <= 1'b0;
            clk_intB   <= 1'b0;
        end else begin
            clk_intA_d <= clk_intA;
            clk_intB   <= clk_intA_d; // one clk_bar cycle delayed clk_intA -> half clk delay relative to clk edge
        end
    end

    // Final output is OR of clk_intA and clk_intB
    assign clk_div = clk_intA | clk_intB;

endmodule