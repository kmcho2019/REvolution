module LFSR (
    input clk,               // Clock signal
    input rst,               // Active-high synchronous reset
    input load,              // Load control signal
    input [3:0] seed,        // Initial seed value
    output reg [3:0] out,    // Current LFSR state
    output reg valid,        // Output valid flag
    output reg repeat_flag   // Sequence repeat indicator
);

// Configurable polynomial (default: x^4 + x^3 + 1)
parameter POLY = 4'b1100;
reg [3:0] counter = 0;

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;
        valid <= 1'b0;
        repeat_flag <= 1'b0;
        counter <= 0;
    end 
    else if (load) begin
        out <= seed;
        valid <= 1'b1;
        repeat_flag <= 1'b0;
        counter <= 1;
    end
    else begin
        // Calculate feedback using configurable polynomial
        out <= {out[2:0], ^(out & POLY)};
        
        // Track sequence cycles
        if (counter == 15) begin
            repeat_flag <= 1'b1;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
        
        // Output becomes valid after first cycle
        if (!valid) valid <= 1'b1;
    end
end

endmodule