module freq_divbyfrac (
    input  wire        clk,        // Input clock signal
    input  wire        rst_n,      // Active low reset signal
    output reg         clk_div     // Fractionally divided clock output
);

// Parameters for the fractional frequency division
localparam MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division
localparam DIV_CLK_P1   = 4;  // Clock cycles for first divided clock period
localparam DIV_CLK_P2   = 3;  // Clock cycles for second divided clock period

// Internal signals
reg [2:0]  counter;  // Counter to track the clock cycles
reg         clk_div_p1;  // First divided clock signal
reg         clk_div_p2;  // Second divided clock signal
reg         clk_div_p1_ph;  // Phase-shifted first divided clock signal
reg         clk_div_p2_ph;  // Phase-shifted second divided clock signal

// Main logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;  // Initialize counter
        clk_div_p1 <= 1'b0;  // Initialize first divided clock signal
        clk_div_p2 <= 1'b0;  // Initialize second divided clock signal
    end else begin
        // Counter logic
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;  // Reset counter
        end else begin
            counter <= counter + 1'b1;  // Increment counter
        end

        // First divided clock signal logic
        if (counter < DIV_CLK_P1) begin
            clk_div_p1 <= 1'b1;  // Assert first divided clock signal
        end else begin
            clk_div_p1 <= 1'b0;  // Deassert first divided clock signal
        end

        // Second divided clock signal logic
        if ((counter >= DIV_CLK_P1) && (counter < MUL2_DIV_CLK)) begin
            clk_div_p2 <= 1'b1;  // Assert second divided clock signal
        end else begin
            clk_div_p2 <= 1'b0;  // Deassert second divided clock signal
        end
    end
end

// Phase-shifting logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_p1_ph <= 1'b0;  // Initialize phase-shifted first divided clock signal
        clk_div_p2_ph <= 1'b0;  // Initialize phase-shifted second divided clock signal
    end else begin
        // Phase-shifted first divided clock signal logic
        if (counter == DIV_CLK_P1 - 1) begin
            clk_div_p1_ph <= 1'b1;  // Assert phase-shifted first divided clock signal
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_p1_ph <= 1'b0;  // Deassert phase-shifted first divided clock signal
        end

        // Phase-shifted second divided clock signal logic
        if (counter == 0) begin
            clk_div_p2_ph <= 1'b1;  // Assert phase-shifted second divided clock signal
        end else if (counter == DIV_CLK_P1) begin
            clk_div_p2_ph <= 1'b0;  // Deassert phase-shifted second divided clock signal
        end
    end
end

// Final fractional divided clock output logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;  // Initialize fractional divided clock output
    end else begin
        // Logically OR the phase-shifted divided clock signals
        clk_div <= clk_div_p1_ph | clk_div_p2_ph;
    end
end

endmodule