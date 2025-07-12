// Define a single D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 1'b0; 
    end else begin
        q <= d;
    end
end

endmodule

// TopModule instantiates 8 DFFs to create an 8-bit register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Define the reset value for each DFF
wire [7:0] reset_values = 8'h34;

// Generate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin: dff_gen
        DFF dff_inst(
           .clk(clk),
           .reset(reset),
           .d(d[i]),
           .q(q[i])
        );
        
        // Add a reset value assignment for each DFF
        initial begin
            if (i == 0) q[i] = reset_values[i];
            else if (i == 1) q[i] = reset_values[i];
            else if (i == 2) q[i] = reset_values[i];
            else if (i == 3) q[i] = reset_values[i];
            else if (i == 4) q[i] = reset_values[i];
            else if (i == 5) q[i] = reset_values[i];
            else if (i == 6) q[i] = reset_values[i];
            else if (i == 7) q[i] = reset_values[i];
        end
    end
endgenerate

endmodule