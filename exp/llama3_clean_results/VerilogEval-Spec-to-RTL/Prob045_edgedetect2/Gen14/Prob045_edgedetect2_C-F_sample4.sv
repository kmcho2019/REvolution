module TopModule(
    input clk,         // Clock signal
    input [7:0] in,   // 8-bit input signal
    output reg [7:0] anyedge // 8-bit output signal indicating edge transitions
);

reg [7:0] prev_in;    // Register to store the previous value of 'in'

// Always block triggered on the positive edge of the clock
always @(posedge clk) begin
    prev_in <= in;
    for (int i = 0; i < 8; i++) begin
        // Use a single XOR operation to detect edge transitions
        anyedge[i] <= in[i] ^ prev_in[i];
    end
end

endmodule