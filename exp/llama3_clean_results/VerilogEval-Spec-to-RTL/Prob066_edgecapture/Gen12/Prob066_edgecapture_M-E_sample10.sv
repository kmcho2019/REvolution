// EdgeDetector module to detect falling edges
module EdgeDetector(
    input  current_in,
    input  prev_in,
    output falling_edge
);

assign falling_edge = prev_in &&!current_in;

endmodule

// TopModule that uses EdgeDetector to detect falling edges and maintain output state
module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

// Instantiate EdgeDetector for each bit of the input signal
wire [31:0] falling_edges;
for (genvar i = 0; i < 32; i++) begin
    EdgeDetector edge_detector_inst (
       .current_in(in[i]),
       .prev_in(prev_in[i]),
       .falling_edge(falling_edges[i])
    );
end

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        // Update prev_in with the current input signal
        prev_in <= in;
        
        // Set output bits based on falling edge detection
        for (int i = 0; i < 32; i++) begin
            if (falling_edges[i]) begin
                out[i] <= 1'b1;
            end else if (out[i] &&!in[i]) begin
                // Keep the output bit high until the input bit goes high again or reset is asserted
                out[i] <= out[i];
            end
        end
    end
end

endmodule