module TopModule (
    input               clk,
    input               reset,
    input     [31:0]     in,
    output reg [31:0]    out
);

reg [31:0] prev_in; // Internal register to store previous state of input signal
reg [31:0] captured; // Internal register to track captured transitions

always @(posedge clk) begin
    if (reset) begin
        // Reset all captured transitions and previous state
        out <= 32'd0;
        prev_in <= 32'd0;
        captured <= 32'd0;
    end else begin
        // Update previous state of input signal
        prev_in <= in;

        // Detect transitions from 1 to 0 and capture them
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] == 1'b1 && in[i] == 1'b0) begin
                captured[i] <= 1'b1;
            end
        end

        // Update output based on captured transitions
        out <= captured;
    end
end

endmodule