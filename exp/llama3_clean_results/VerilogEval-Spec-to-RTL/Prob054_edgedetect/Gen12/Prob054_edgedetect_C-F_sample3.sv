module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    for (int i = 0; i < 8; i++) begin
        // Using the detection logic from Example 2 for clarity and simplicity
        pedge[i] <= (in[i] == 1'b1) && (prev_in[i] == 1'b0);  // detect 0 to 1 transition for bit i
    end
end

endmodule