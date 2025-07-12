module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Combinational next state logic
wire [63:0] next_Q = !rst_n ? 64'b0 : 
                    (Q[0] == 1'b0) ? {1'b1, Q[63:1]} : 
                    {1'b0, Q[63:1]};

// Sequential element
always @(posedge clk or negedge rst_n) begin
    Q <= next_Q;
end

endmodule