module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0; // Reset the counter to 0 when rst_n is low
    end else begin
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]}; // Increment by shifting right and appending 1 at MSB
        end else begin
            Q <= {1'b0, Q[63:1]}; // Decrement by shifting right and appending 0 at MSB
        end
    end
end

endmodule