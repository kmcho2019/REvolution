module TopModule (
    input       clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input signal

always @ (posedge clk) begin
    prev_in <= in; // Store the current input signal at the rising edge of the clock
end

always @ (*) begin
    for (int i = 0; i < 8; i++) begin
        pedge[i] = prev_in[i] == 1'b0 && in[i] == 1'b1; // Detect the positive edge
    end
end

endmodule