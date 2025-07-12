module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Parallel prefix computation for next state
wire [63:0] Q_next;
genvar i;
generate
    for (i = 0; i < 64; i = i + 1) begin : parallel_prefix
        assign Q_next[i] = (i == 63) ? ~Q[0] : Q[i+1];
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low synchronous reset
    end else begin
        Q <= Q_next;
        
        // Optional power optimization - freeze counter when not needed
        // if (Q == 64'hFFFFFFFFFFFFFFFF || Q == 64'h0) Q <= Q;
    end
end

// Optional pipeline registers for high-frequency operation
// reg [63:0] Q_pipe;
// always @(posedge clk) Q_pipe <= Q_next;
// assign Q = Q_pipe;

endmodule