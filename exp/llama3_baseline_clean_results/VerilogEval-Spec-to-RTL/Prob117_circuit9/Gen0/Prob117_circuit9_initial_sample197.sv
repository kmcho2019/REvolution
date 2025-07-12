module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (a) begin
        if (q == 3'b111) begin // Start from 4 when wrapping around from 7
            q <= 4;
        end else if (q == 0) begin // If 'a' was 1 at power-up, start at 4
            q <= 4;
        end else begin
            q <= 4; // Keep at 4 when 'a' is high
        end
    end else begin // a is 0, increment counter
        if (q == 4) begin
            q <= q + 1;
        end else if (q == 7) begin // Wrap around from 7 to 0
            q <= 0;
        end else begin
            q <= q + 1; // Increment counter
        end
    end
end

initial begin
    q = 4; // Initialize output to 4 when 'a' is 1 at power-up
end

endmodule