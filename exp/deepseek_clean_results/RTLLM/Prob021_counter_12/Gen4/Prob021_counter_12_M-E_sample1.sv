module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output wire [3:0] out      // 4-bit counter output
);

reg [3:0] j_counter;  // Johnson counter register
wire terminal_count;

// Johnson counter implementation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        j_counter <= 4'b0000;
    end else if (valid_count) begin
        j_counter <= {~j_counter[0], j_counter[3:1]};
    end
end

// Terminal count detection (state 4'b1000)
assign terminal_count = (j_counter == 4'b1000);

// State decode logic to convert Johnson sequence to 0-11 count
assign out = 
    (j_counter == 4'b0000) ? 4'b0000 :  // 0
    (j_counter == 4'b1000) ? 4'b0001 :   // 1
    (j_counter == 4'b1100) ? 4'b0010 :   // 2
    (j_counter == 4'b1110) ? 4'b0011 :   // 3
    (j_counter == 4'b1111) ? 4'b0100 :   // 4
    (j_counter == 4'b0111) ? 4'b0101 :   // 5
    (j_counter == 4'b0011) ? 4'b0110 :   // 6
    (j_counter == 4'b0001) ? 4'b0111 :   // 7
    (j_counter == 4'b1001) ? 4'b1000 :   // 8 (special state)
    (j_counter == 4'b1101) ? 4'b1001 :   // 9
    (j_counter == 4'b1111) ? 4'b1010 :   // 10 (reuse state)
    (j_counter == 4'b0111) ? 4'b1011 :   // 11 (reuse state)
    4'b0000;                             // default

// Special handling to skip unused Johnson states
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset handled in main counter
    end else if (valid_count && terminal_count) begin
        // Force jump to next valid state in sequence
        j_counter <= 4'b1001;
    end
end

endmodule