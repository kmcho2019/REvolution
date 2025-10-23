module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Internal wires for flip-flop connections
wire [7:0] mux_out;

// Generate block for scalable implementation
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : reg_loop
        // 2:1 MUX for each flip-flop input (parallel load by default)
        assign mux_out[i] = d[i];  // Could add control signal here for shift/load modes
        
        // Positive edge-triggered D flip-flop
        always @(posedge clk) begin
            q[i] <= mux_out[i];
        end
    end
endgenerate

endmodule