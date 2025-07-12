module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Initialize q to 0 for defined startup state (simulation clarity)
    initial begin
        q = 1'b0;
    end

    always @(posedge clk) begin
        q <= d;  // Nonblocking assignment for synchronous update
    end
endmodule