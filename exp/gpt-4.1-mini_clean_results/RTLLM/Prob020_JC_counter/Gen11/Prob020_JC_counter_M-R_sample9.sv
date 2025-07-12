module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

wire [63:0] next_state;

assign next_state = {~Q[0], Q[63:1]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= next_state;
end

endmodule