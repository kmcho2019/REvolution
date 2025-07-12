module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] counter;

    // clk_intA and clk_intB as combinational signals derived directly from counter
    wire clk_intA;
    wire clk_intB;

    // Phase shifted version of clk_intB by sampling on negedge clk
    reg clk_intB_phase_shift;

    // -------- Counter --------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'd0;
        else begin
            if (counter == 3'd6)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;
        end
    end

    // -------- Combinational pulse generation --------
    // clk_intA: high for counter values 0..3 (4 cycles)
    assign clk_intA = (counter <= 3'd3);

    // clk_intB: high for counter values 0..2 (3 cycles)
    assign clk_intB = (counter <= 3'd2);

    // -------- Phase shift clk_intB by half clock using negedge clk --------
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB_phase_shift <= 1'b0;
        else
            clk_intB_phase_shift <= clk_intB;
    end

    // -------- Final fractional divided clock --------
    assign clk_div = clk_intA | clk_intB_phase_shift;

endmodule