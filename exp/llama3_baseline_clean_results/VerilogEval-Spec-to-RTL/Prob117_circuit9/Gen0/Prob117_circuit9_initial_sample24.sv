module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (!a) begin
        if (q == 5) begin
            q <= 0;
        end else if (q == 6) begin
            q <= 0;  // Not directly observed in the given waveform, but follows from the counter's behavior
        end else begin
            q <= q + 1;
        end
    end
end

initial begin
    q <= 4;
end

endmodule