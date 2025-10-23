module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0; // Reset to 0 when rst_n is low
    end else begin
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]}; // Shift right and append 1 at MSB
        end else begin
            Q <= {1'b0, Q[63:1]}; // Shift right and append 0 at MSB
        end
    end
end

endmodule