module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Next state logic for Johnson counter
wire [63:0] next_Q = {~Q[0], Q[63:1]};

// Register with synchronous reset
always @(posedge clk) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= next_Q;
    end
end

endmodule