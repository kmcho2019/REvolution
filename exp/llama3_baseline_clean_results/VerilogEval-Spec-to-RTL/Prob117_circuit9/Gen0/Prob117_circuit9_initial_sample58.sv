module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

initial q = 4; // Initialize q to 4 as per the waveform

always @(posedge clk) begin
    if (~a) begin // Increment q only when a is low
        if (q == 7) begin
            q <= 0; // Wrap around to 0 after reaching 7
        end else begin
            q <= q + 1;
        end
    end
end

endmodule