module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    wire clk_d;       // Delayed version of clk (one cycle delayed)
    wire rising_edge; // High for one clk cycle after rising edge
    wire falling_edge;// High for one clk cycle after falling edge

    reg d_reg_pos;    // Registered d on posedge
    reg d_reg_neg;    // Registered d on negedge

    reg q_pos;
    reg q_neg;

    // Delay clk by one cycle to detect edges
    reg clk_reg;
    always @(posedge clk) begin
        clk_reg <= clk;
    end
    assign clk_d = clk_reg;

    // Edge detection logic (clk and clk_d delayed clk)
    // rising_edge: clk was 0, now 1
    assign rising_edge = (~clk_d) & clk;
    // falling_edge: clk was 1, now 0
    assign falling_edge = clk_d & (~clk);

    // Clock gating for FF enables
    // We'll only clock posedge FF on rising edge pulses
    // and negedge FF on falling edge pulses

    // Positive-edge triggered FF enabled only on rising edges
    always @(posedge clk) begin
        if (rising_edge)
            q_pos <= d;
    end

    // Negative-edge triggered FF enabled only on falling edges
    always @(posedge clk) begin
        if (falling_edge)
            q_neg <= d;
    end

    // Output muxed by clk level to reflect latest sampled data on that level
    assign q = clk ? q_pos : q_neg;

endmodule