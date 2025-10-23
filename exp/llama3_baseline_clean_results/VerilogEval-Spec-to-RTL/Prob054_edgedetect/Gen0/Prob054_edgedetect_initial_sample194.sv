module TopModule(
    input               clk,
    input       [7:0]   in,
    output reg  [7:0]   pedge
);

reg [7:0] prev_in; // Register to store previous input values

always @(posedge clk) begin
    prev_in <= in; // Update previous input values on every clock cycle
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        pedge[i] = (prev_in[i] == 1'b0) && (in[i] == 1'b1); // Positive edge detection
    end
end

endmodule