module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute async_reg of Q is true;  // Help with timing closure
// synthesis attribute shreg_extract of Q is "no";  // Prevent shift register optimization

// Next state calculation as continuous assignment
wire [63:0] next_Q = {~Q[0], Q[63:1]};

// Reset handling
always @(negedge rst_n) begin
    if (!rst_n) Q <= 64'b0;
end

// State update (clocked)
always @(posedge clk) begin
    Q <= next_Q;
    
    // For power optimization: Could add clock gating when Q is all 1s or all 0s
    // if (Q == 64'hFFFFFFFFFFFFFFFF || Q == 64'h0) disable counter;
end

endmodule