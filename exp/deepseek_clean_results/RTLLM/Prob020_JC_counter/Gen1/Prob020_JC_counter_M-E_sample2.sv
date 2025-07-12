module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] pattern_gen;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        pattern_gen <= 64'b0;
    end
    else begin
        // Parallel pattern generation
        pattern_gen <= {64{Q[0]}};
        
        // Next state calculation
        Q <= (Q >> 1) | (~pattern_gen & 64'h8000_0000_0000_0000);
    end
end

endmodule