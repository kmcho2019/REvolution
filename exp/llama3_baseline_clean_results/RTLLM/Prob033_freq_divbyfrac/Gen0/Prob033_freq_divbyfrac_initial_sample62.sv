module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the number of clock cycles for the fractional division (3.5x)
localparam MUL2_DIV_CLK = 7;

// Counter to track the clock cycles
reg [2:0] counter;

// Signals to generate the intermediate divided clock signals
reg div_clk_4;
reg div_clk_3;

// Phase-shifted versions of the divided clock signals
reg div_clk_4_ph;
reg div_clk_3_ph;

// Intermediate signals
reg clk_div_int;

// Initialize the counter and signals
initial begin
    counter = 0;
    div_clk_4 = 0;
    div_clk_3 = 0;
    div_clk_4_ph = 0;
    div_clk_3_ph = 0;
    clk_div_int = 0;
end

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        div_clk_4 <= 0;
        div_clk_3 <= 0;
        div_clk_4_ph <= 0;
        div_clk_3_ph <= 0;
        clk_div_int <= 0;
    end
end

// Counter logic
always @(posedge clk) begin
    if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

// Generate the intermediate divided clock signals
always @(posedge clk) begin
    case (counter)
        0, 1, 2, 3: div_clk_4 <= 1;
        default: div_clk_4 <= 0;
    endcase

    case (counter)
        4, 5, 6: div_clk_3 <= 1;
        default: div_clk_3 <= 0;
    endcase
end

// Phase-shift the divided clock signals
always @(posedge clk) begin
    div_clk_4_ph <= div_clk_4;
    div_clk_3_ph <= div_clk_3;
end

always @(negedge clk) begin
    div_clk_4_ph <= div_clk_4_ph;
    div_clk_3_ph <= div_clk_3_ph;
end

// Logically OR the intermediate clocks to produce the final fractional divided clock output
assign clk_div = div_clk_4_ph | div_clk_3_ph;

endmodule