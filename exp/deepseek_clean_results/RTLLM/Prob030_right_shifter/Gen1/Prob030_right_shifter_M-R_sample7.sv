module right_shifter (
    input clk,
    input reset_n,  // Active-low asynchronous reset
    input d,
    output reg [7:0] q
);

wire [7:0] next_q;

assign next_q = {d, q[7:1]};  // Combinational logic for next state

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 8'b0;  // Asynchronous reset
    end else begin
        q <= next_q;  // Synchronous operation
    end
end

endmodule