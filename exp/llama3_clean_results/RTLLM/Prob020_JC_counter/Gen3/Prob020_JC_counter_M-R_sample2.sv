module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q; // Temporary variable to hold the next state

always @* begin
    if (~rst_n) begin
        next_Q = 64'd0; // Reset the counter value to 0 when rst_n is low
    end else begin
        if (Q[0] == 1'b0) begin
            next_Q = {1'b1, Q[63:1]}; // Shift right and append 1 at MSB when Q[0] is 0
        end else begin
            next_Q = {1'b0, Q[63:1]}; // Shift right and append 0 at MSB when Q[0] is 1
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    Q <= next_Q; // Update Q on every rising edge of clk or falling edge of rst_n
end

endmodule