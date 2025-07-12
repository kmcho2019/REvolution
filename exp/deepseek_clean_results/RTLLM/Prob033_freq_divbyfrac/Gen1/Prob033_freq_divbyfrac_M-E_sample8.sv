module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters
parameter INTEGER_DIV = 3;    // Integer division factor
parameter FRAC_CYCLES = 2;    // For 0.5x, we need 2 fractional events per integer cycle

// Internal signals
reg [2:0] int_counter;        // Integer counter (0 to 2)
reg frac_pulse;              // Fractional pulse signal
reg [1:0] frac_counter;      // Fractional counter (0 to 1)

// Integer counter (3x division)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        int_counter <= 0;
    end
    else begin
        if (int_counter == INTEGER_DIV - 1)
            int_counter <= 0;
        else
            int_counter <= int_counter + 1;
    end
end

// Fractional counter (triggers every 1.5 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        frac_counter <= 0;
    end
    else begin
        if (frac_counter == FRAC_CYCLES - 1)
            frac_counter <= 0;
        else
            frac_counter <= frac_counter + 1;
    end
end

// Fractional pulse generation (half-cycle pulses)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        frac_pulse <= 0;
    end
    else begin
        // Generate pulse at specific fractional boundaries
        frac_pulse <= (frac_counter == 1) && (int_counter == 1);
    end
end

// Base 3x divided clock
wire base_clk;
assign base_clk = (int_counter < (INTEGER_DIV/2 + INTEGER_DIV%2));

// Final output combining base clock and fractional pulses
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end
    else begin
        clk_div <= base_clk ^ frac_pulse;
    end
end

endmodule