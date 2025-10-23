module TopModule (
    input            clk,
    input      [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    // Synchronous reset could be added if desired; here we assume power-up reset is handled externally
    // Detect rising edge per bit: current input is 1 and previous input was 0
    always @(posedge clk) begin
        pedge   <= in & ~prev_in;
        prev_in <= in;
    end

endmodule