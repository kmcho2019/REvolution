module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

wire [63:0] next_Q;

// Combinational next-state logic
assign next_Q = {~Q[0], Q[63:1]};  // Johnson counter operation

// Sequential state storage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= next_Q;
    end
end

endmodule