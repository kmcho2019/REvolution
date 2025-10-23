module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        if (Q[0] == 0) begin
            Q <= {1'b1, Q[63:1]};
        end else begin
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule