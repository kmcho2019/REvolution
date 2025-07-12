module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam integer DIV_TOTAL = 7; // counts total for 3.5 division (2*3.5)
    
    reg [2:0] count_rise;  // Counter increments on posedge clk
    reg [2:0] count_fall;  // Counter increments on negedge clk
    
    // Intermediate clocks toggled at different counts for uneven periods
    reg clk_intA_rise;
    reg clk_intB_fall;
    
    // Count on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count_rise <= 3'd0;
        else if (count_rise == DIV_TOTAL-1)
            count_rise <= 3'd0;
        else
            count_rise <= count_rise + 3'd1;
    end
    
    // Count on negedge clk (same counter delayed by half cycle)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            count_fall <= 3'd0;
        else if (count_fall == DIV_TOTAL-1)
            count_fall <= 3'd0;
        else
            count_fall <= count_fall + 3'd1;
    end

    // Generate clk_intA: High for 4 counts, Low for 3 counts, on posedge clk domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intA_rise <= 1'b0;
        else if (count_rise < 4)
            clk_intA_rise <= 1'b1;
        else
            clk_intA_rise <= 1'b0;
    end

    // Generate clk_intB: High for 3 counts, Low for 4 counts, on negedge clk domain
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB_fall <= 1'b0;
        else if (count_fall < 3)
            clk_intB_fall <= 1'b1;
        else
            clk_intB_fall <= 1'b0;
    end

    // Output clk_div is logical OR of the two intermediate clocks
    // This combines two clocks out of phase by half input clock period,
    // resulting in a smoother clock with frequency input_clk/3.5
    assign clk_div = clk_intA_rise | clk_intB_fall;

endmodule