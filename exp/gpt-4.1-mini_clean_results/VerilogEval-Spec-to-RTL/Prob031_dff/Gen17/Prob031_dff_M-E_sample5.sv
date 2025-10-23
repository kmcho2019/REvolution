module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    // Optional synchronous reset: not connected to inputs, just demonstrates extensibility
    wire reset = 1'b0;

    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

    // Initialization for simulation clarity (may or may not map to hardware reset)
    initial begin
        q = 1'b0;
    end

endmodule