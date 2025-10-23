module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        Q <= 64'd0;
    end else begin
        if (Q[0] == 1'b0) begin // Increment if Q[0] is 0
            Q <= {1'b1, Q[63:1]};
        end else begin // Decrement if Q[0] is 1
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule