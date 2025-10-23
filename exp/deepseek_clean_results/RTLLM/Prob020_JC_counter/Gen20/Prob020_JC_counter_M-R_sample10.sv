module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Next state calculation using continuous assignment
wire [63:0] next_Q = !rst_n ? 64'b0 : {~Q[0], Q[63:1]};

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule