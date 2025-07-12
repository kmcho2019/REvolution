module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [31:0] Q_upper, Q_lower;
wire counter_enable = (Q != {64{Q[0]}}); // Enable when not in steady state

always @(posedge clk) begin
    if (!rst_n) begin
        Q <= 64'b0;
        Q_upper <= 32'b0;
        Q_lower <= 32'b0;
    end
    else if (counter_enable) begin
        // First pipeline stage - process lower 32 bits
        Q_lower <= {~Q[0], Q[31:1]};
        
        // Second pipeline stage - process upper 32 bits
        Q_upper <= {Q[32], Q[63:33]};
        
        // Final output
        Q <= {Q_upper, Q_lower};
    end
end

endmodule