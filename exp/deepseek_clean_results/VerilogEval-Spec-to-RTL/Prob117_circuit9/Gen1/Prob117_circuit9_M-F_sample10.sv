module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg initialized = 0;

always @(posedge clk) begin
    if (!initialized) begin
        q <= 3'b100; // Initialize q to 4 on first clock edge
        initialized <= 1;
    end else begin
        if (a) begin
            q <= q; // Hold value when a is 1
        end else begin
            if (q == 3'b110) // If q is 6
                q <= 3'b000;  // Wrap around to 0
            else
                q <= q + 1;  // Increment otherwise
        end
    end
end

endmodule