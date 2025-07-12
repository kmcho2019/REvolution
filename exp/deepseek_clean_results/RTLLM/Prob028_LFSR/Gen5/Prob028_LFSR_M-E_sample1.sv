module LFSR (
    input clk,                // Clock signal
    input rst,                // Active-high synchronous reset
    output reg [3:0] out,     // Current LFSR state
    output [3:0] next_out,    // Next state (combinational)
    output [3:0] future_out,  // State after next (combinational)
    output reg valid,         // Output valid flag
    output reg [1:0] quality  // Randomness quality metric (00=worst, 11=best)
);

// Simulated temperature sensor input (4 LSBs of time counter)
reg [31:0] temp_sensor = 0;
wire [3:0] seed = temp_sensor[3:0];

// Dynamic polynomial selection
wire [3:0] poly_select = out[0] ? 4'b1100 : 4'b1010; // Alternate between two polynomials

// Current feedback calculation
wire feedback = ^(out & poly_select);

// Next state calculation
assign next_out = {out[2:0], feedback};
assign future_out = {next_out[2:0], ^(next_out & poly_select)};

// Statistical testing registers
reg [15:0] bit_history = 0;
reg [3:0] transition_count = 0;

always @(posedge clk) begin
    temp_sensor <= temp_sensor + 1;  // Simulate changing sensor input
    
    if (rst) begin
        // Self-seeding with sensor input if all zeros
        out <= (seed == 0) ? 4'b0001 : seed;
        valid <= 1'b0;
        quality <= 2'b00;
        bit_history <= 0;
        transition_count <= 0;
    end 
    else begin
        // Update LFSR state
        out <= next_out;
        
        // Update statistical tracking
        bit_history <= {bit_history[14:0], feedback};
        transition_count <= transition_count + ^{out, next_out};
        
        // Calculate quality metric (simple transition count)
        quality <= (transition_count > 12) ? 2'b11 :
                  (transition_count > 8)  ? 2'b10 :
                  (transition_count > 4)  ? 2'b01 : 2'b00;
        
        // Output becomes valid after first cycle
        if (!valid) valid <= 1'b1;
    end
end

// Gray code conversion for low-power applications
function [3:0] binary_to_gray;
    input [3:0] bin;
    binary_to_gray = {bin[3], bin[3]^bin[2], bin[2]^bin[1], bin[1]^bin[0]};
endfunction

wire [3:0] gray_out = binary_to_gray(out);

endmodule