module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

initial begin
    q = 3'b100; // Initialize to 4 as seen in waveform
end

always @(posedge clk) begin
    if (a) begin
        q <= q; // Hold value when a is high
    end else begin
        // Increment and wrap around after 6
        if (q == 3'b110) begin
            q <= 3'b000;
        end else begin
            q <= q + 1;
        end
    end
end

endmodule