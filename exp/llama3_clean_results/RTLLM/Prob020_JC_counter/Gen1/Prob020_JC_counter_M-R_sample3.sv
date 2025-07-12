module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q;

// Combinational logic block to determine the next state
always @(*) begin
    if (!rst_n) begin
        next_Q = 64'd0;
    end else begin
        if (Q[0] == 1'b0) begin
            next_Q = {1'b1, Q[63:1]};
        end else begin
            next_Q = {1'b0, Q[63:1]};
        end
    end
end

// Sequential logic block to update the current state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'd0;
    end else begin
        Q <= next_Q;
    end
end

endmodule