module freq_divbyfrac (
    input  wire clk,       // Input clock signal
    input  wire rst_n,     // Active low reset signal
    output wire clk_div    // Fractionally divided clock output
);

// Define parameters
parameter MUL2_DIV_CLK = 7;  // Number of clock cycles for 3.5x division

// Internal signals
reg [2:0] counter;           // Counter to cycle through 7 clock cycles
reg clk_div_int1;            // Intermediate divided clock signal 1
reg clk_div_int2;            // Intermediate divided clock signal 2
reg clk_div_int1_delayed;    // Delayed version of intermediate divided clock signal 1
reg clk_div_int2_advanced;   // Advanced version of intermediate divided clock signal 2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;  // Reset counter to 0
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;  // Reset counter to 0 after reaching 7
        end else begin
            counter <= counter + 1'b1;  // Increment counter
        end
    end
end

// Generate intermediate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0;  // Reset intermediate divided clock signal 1 to 0
        clk_div_int2 <= 1'b0;  // Reset intermediate divided clock signal 2 to 0
    end else begin
        if (counter == 3'b100) begin  // After 4 clock cycles
            clk_div_int1 <= 1'b1;  // Set intermediate divided clock signal 1 to 1
        end else if (counter == 3'b011) begin  // After 3 clock cycles
            clk_div_int1 <= 1'b0;  // Set intermediate divided clock signal 1 to 0
        end
        
        if (counter == 3'b101) begin  // After 5 clock cycles
            clk_div_int2 <= 1'b1;  // Set intermediate divided clock signal 2 to 1
        end else if (counter == 3'b010) begin  // After 2 clock cycles
            clk_div_int2 <= 1'b0;  // Set intermediate divided clock signal 2 to 0
        end
    end
end

// Generate phase-shifted versions of intermediate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1_delayed <= 1'b0;  // Reset delayed intermediate divided clock signal 1 to 0
        clk_div_int2_advanced <= 1'b0;  // Reset advanced intermediate divided clock signal 2 to 0
    end else begin
        clk_div_int1_delayed <= clk_div_int1;  // Delay intermediate divided clock signal 1 by half a clock period
        clk_div_int2_advanced <= clk_div_int2;  // Advance intermediate divided clock signal 2 by half a clock period
    end
end

// Generate final fractional divided clock output
assign clk_div = (clk_div_int1 || clk_div_int2) || (clk_div_int1_delayed || clk_div_int2_advanced);

endmodule