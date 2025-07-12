module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

wire [63:0] next_Q;

// Combinational logic for next state
assign next_Q = {~Q[0], Q[63:1]};

// Sequential element with synchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= next_Q;
    end
end

endmodule