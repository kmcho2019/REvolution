module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Parameterized for potential reuse (though fixed to 8 bits per spec)
parameter WIDTH = 8;

// Generate block for explicit flip-flop instantiation
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : dff_chain
        always @(posedge clk) begin
            if (reset) begin
                q[i] <= 1'b0;  // Synchronous reset
            end
            else begin
                q[i] <= d[i];  // Data transfer
            end
        end
    end
endgenerate

endmodule