module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Next state calculation
wire [63:0] next_Q;
assign next_Q = (Q[0] == 1'b0) ? {1'b1, Q[63:1]} : {1'b0, Q[63:1]};

// Sequential logic for register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= next_Q;
    end
end

endmodule