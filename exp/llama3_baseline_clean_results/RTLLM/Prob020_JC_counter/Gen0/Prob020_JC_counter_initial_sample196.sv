module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        Q <= 64'd0;
    end else begin
        if (Q[0] == 1'b0) begin // LSB is 0, append 1 to MSB
            Q <= {1'b1, Q[63:1]};
        end else begin // LSB is 1, append 0 to MSB
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule