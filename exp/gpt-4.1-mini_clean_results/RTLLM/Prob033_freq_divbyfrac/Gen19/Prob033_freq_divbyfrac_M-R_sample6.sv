module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV2 = 7; // total half cycles for 3.5 division (7 half-cycles)

    // Counter from 0 to 6, wraps around
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV2 - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate toggle pulses for clk_pos on counts 0 and 4 (half periods of 4 cycles)
    wire pulse_pos = (cnt == 3'd0) || (cnt == 3'd4);

    // Generate toggle pulses for clk_neg on counts 1 and 5 (half periods of 3 cycles)
    wire pulse_neg = (cnt == 3'd1) || (cnt == 3'd5);

    // clk_pos toggles on pulse_pos at posedge clk
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (pulse_pos)
            clk_pos <= ~clk_pos;
    end

    // clk_neg toggles on pulse_neg at posedge clk
    reg clk_neg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (pulse_neg)
            clk_neg <= ~clk_neg;
    end

    // Combine the two phased clocks to get fractional divided clock
    assign clk_div = clk_pos | clk_neg;

endmodule