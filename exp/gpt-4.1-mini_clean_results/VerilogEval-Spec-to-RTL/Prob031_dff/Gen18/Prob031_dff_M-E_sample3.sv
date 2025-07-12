module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    // Initialize q to 0 on startup (simulation friendly)
    initial q = 1'b0;

    // Synchronous D flip-flop logic: on posedge clk, q follows d
    always @(posedge clk) begin
        q <= d;
    end

endmodule