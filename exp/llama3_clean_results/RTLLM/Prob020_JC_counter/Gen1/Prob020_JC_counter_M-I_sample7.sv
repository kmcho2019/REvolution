module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0; // Reset the counter to 0 when rst_n is low
    end else begin
        // Directly manipulate Q based on its least significant bit
        if (Q[0] == 1'b0) begin
            Q[63] <= 1'b1;
        end else begin
            Q[63] <= 1'b0;
        end
        // Shift Q right, keeping the new MSB set above
        Q[62:0] <= Q[63:1];
    end
end

endmodule