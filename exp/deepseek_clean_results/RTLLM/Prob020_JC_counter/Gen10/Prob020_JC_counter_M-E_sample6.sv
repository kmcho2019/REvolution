module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

wire [63:0] next_state_0 = {1'b1, Q[63:1]};  // Pre-compute state when Q[0]==0
wire [63:0] next_state_1 = {1'b0, Q[63:1]};  // Pre-compute state when Q[0]==1
wire [63:0] next_state = Q[0] ? next_state_1 : next_state_0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= next_state;
    end
end

endmodule