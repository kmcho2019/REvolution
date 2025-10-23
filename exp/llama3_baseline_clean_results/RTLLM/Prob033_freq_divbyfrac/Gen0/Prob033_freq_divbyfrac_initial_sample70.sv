module freq_divbyfrac (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output clk_div // Fractionally divided clock output
);

// Define parameters
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt; // Counter to track clock cycles
reg clk_div_int1; // Intermediate divided clock signal 1
reg clk_div_int2; // Intermediate divided clock signal 2
reg prev_clk; // Previous clock value to detect rising/falling edges

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000; // Reset counter
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000; // Wrap around after 7 cycles
        end else begin
            cnt <= cnt + 1'b1; // Increment counter
        end
    end
end

// Generate intermediate divided clock signals
always @(posedge clk) begin
    prev_clk <= clk; // Store previous clock value
    
    // Generate intermediate clock signals based on counter value
    if (cnt < 3'b100) begin // First 4 cycles
        clk_div_int1 <= 1'b1; // Set clk_div_int1 high
    end else begin
        clk_div_int1 <= 1'b0; // Set clk_div_int1 low
    end
    
    // Generate second intermediate clock signal with a phase shift
    if (cnt >= 3'b011 && cnt < 3'b101) begin // Middle 3 cycles
        clk_div_int2 <= 1'b1; // Set clk_div_int2 high
    end else begin
        clk_div_int2 <= 1'b0; // Set clk_div_int2 low
    end
end

// Generate final divided clock output
assign clk_div = (clk_div_int1 | clk_div_int2);

endmodule