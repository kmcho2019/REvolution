// Novel module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    input  clk,      // Clock signal
    output parity    // 1-bit output for even parity
);

reg [7:0] shift_reg;  // Shift register to hold the input byte
reg [0:0] parity_reg;  // Register to hold the accumulated parity
reg [2:0] counter;    // Counter to track the number of shifts

// Initialize the shift register and parity register
initial begin
    shift_reg = 8'd0;
    parity_reg = 1'd0;
    counter = 3'd0;
end

// Sequential logic to calculate the parity bit
always @(posedge clk) begin
    if (counter < 3'd8) begin
        // Shift the input byte and accumulate the parity
        shift_reg = {in[7-counter], shift_reg[7:1]};
        parity_reg = parity_reg ^ shift_reg[0];
        counter = counter + 1'd1;
    end
end

// Assign the final parity bit to the output
assign parity = parity_reg;

endmodule