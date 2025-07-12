// DFF module with active high synchronous reset and negative edge triggering
module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 1'b0; // Reset value is determined by TopModule
    end else begin
        q <= d;
    end
end

endmodule

// TopModule with 8 DFFs
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Reset values for each DFF
wire [7:0] reset_values = 8'h34;

// Instantiate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        DFF dff_i(
           .clk(clk),
           .reset(reset),
           .d(d[i]),
           .q(q[i])
        );
        // Assign reset value to each DFF
        initial q[i] = reset_values[i];
    end
endgenerate

endmodule