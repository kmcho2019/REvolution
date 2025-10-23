module TopModule(
    input               clk,
    input      [7:0]    in,
    output reg [7:0]    pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in; // Update the previous state on each clock cycle
    pedge   <= (in & (~prev_in)); // Detect transitions from 0 to 1
end

endmodule