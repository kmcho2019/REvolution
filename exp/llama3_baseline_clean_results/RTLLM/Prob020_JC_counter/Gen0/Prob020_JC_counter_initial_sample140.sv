module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0; // reset the counter
    end else begin
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]}; // increment the counter
        end else begin
            Q <= {1'b0, Q[63:1]}; // decrement the counter
        end
    end
end

endmodule