module freq_divbyfrac (
    input  wire clk,     // Input clock
    input  wire rst_n,   // Active low asynchronous reset
    output wire clk_div  // Fractionally divided output clock (divide by 3.5)
);

    // Counters count 0..6 (7 counts total), representing half-cycles
    reg [2:0] counter_posedge;  // Counter clocked on posedge clk
    reg [2:0] counter_negedge;  // Counter clocked on negedge clk

    // Intermediate clock signals from posedge and negedge domains
    reg clk_intA;
    reg clk_intB;

    // Reset synchronous registers in posedge domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter_posedge <= 3'd0;
        else if (counter_posedge == 3'd6)
            counter_posedge <= 3'd0;
        else
            counter_posedge <= counter_posedge + 3'd1;
    end

    // Generate clk_intA in posedge clk domain:
    // High for 4 half-cycles (counts 0..3), low for 3 half-cycles (4..6)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intA <= 1'b0;
        else if (counter_posedge <= 3'd3)
            clk_intA <= 1'b1;
        else
            clk_intA <= 1'b0;
    end

    // Reset synchronous registers in negedge domain
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            counter_negedge <= 3'd0;
        else if (counter_negedge == 3'd6)
            counter_negedge <= 3'd0;
        else
            counter_negedge <= counter_negedge + 3'd1;
    end

    // Generate clk_intB in negedge clk domain:
    // High for 3 half-cycles (counts 0..2), low for 4 half-cycles (3..6)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB <= 1'b0;
        else if (counter_negedge <= 3'd2)
            clk_intB <= 1'b1;
        else
            clk_intB <= 1'b0;
    end

    // Combine the two phase-shifted intermediate clocks to form the final output
    assign clk_div = clk_intA | clk_intB;

endmodule