// Novel module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Internal signals
reg [2:0] counter; // Counter to keep track of 1s
reg [7:0] shift_reg; // Shift register for input byte
reg clk; // Clock signal for sequential operation

// Initialize counter and shift register
initial begin
    counter = 0;
    shift_reg = in;
end

// Sequential logic to count 1s in the input byte
always @(posedge clk) begin
    if (shift_reg[0] == 1) begin
        counter <= counter + 1;
    end
    shift_reg <= shift_reg >> 1;
end

// Generate parity bit based on counter value
assign parity = (counter % 2 == 1)? 1 : 0;

// For simulation purposes, generate a clock signal
initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

// For simulation purposes, stop the clock after 8 cycles
initial #9 $finish;

endmodule