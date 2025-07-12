module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

initial q = 3'bxxx; // Initialize q with unknown value

always @(posedge clk) begin
    if (a) begin
        q <= 4; // Reset q to 4 when a is high
    end else begin
        if (q == 7) begin
            q <= 0; // Wrap around to 0 when q reaches 7
        end else if (q == 0) begin
            q <= 1; // Start from 1 after wrapping around
        end else begin
            q <= q + 1; // Increment q by 1
        end
    end
end

endmodule