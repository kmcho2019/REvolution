module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] seq; // 4-bit sequence register

always @(posedge clk) begin
    if (reset) begin
        seq <= 4'b0000; // Reset sequence
        start_shifting <= 0; // Reset start_shifting
    end else begin
        seq <= {seq[2:0], data}; // Shift in new data
        if (seq == 4'b1101) begin
            start_shifting <= 1; // Set start_shifting if sequence detected
        end
    end
end

endmodule