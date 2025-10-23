// Novel module to calculate the even parity bit for an 8-bit input byte using a flip-flop and feedback loop
module TopModule(
    input  clk,       // Clock signal
    input  rst_n,     // Active low reset
    input  [7:0] in,  // 8-bit input byte
    input  start,     // Start signal to initiate parity calculation
    output parity      // 1-bit output for even parity
);

reg [2:0] count;  // Counter to track bit position
reg parity_reg;   // Register to hold the parity bit

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 3'b000;  // Reset counter
        parity_reg <= 1'b0;  // Reset parity register
    end else if (start) begin
        // Initialize counter and parity on start signal
        count <= 3'b000;
        parity_reg <= in[0];  // Start with the first bit
    end else if (count < 3'b111) begin
        // Increment counter and update parity
        count <= count + 1;
        parity_reg <= parity_reg ^ in[count];  // XOR with current bit
    end
end

assign parity = parity_reg;  // Output the final parity bit when count reaches 8

endmodule