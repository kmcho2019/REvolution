module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= in; // Initialize prev_in with the current input value at reset
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] &&!in[i]) begin // Falling edge detection
                out[i] <= 1'b1; // Set output bit to 1
            end else begin
                // Retain the previous output value if no falling edge is detected
                // This is the key fix: explicitly retaining the output value
                out[i] <= out[i]; 
            end
        end
        prev_in <= in; // Update previous input value
    end
end

endmodule