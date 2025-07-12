module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0; // Reset the counter value to 0 on reset
    end else begin
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]}; // Shift the current value to the right and append a 1 at the most significant bit position
        end else begin
            Q <= {1'b0, Q[63:1]}; // Shift the current value to the right and append a 0 at the most significant bit position
        end
    end
end

endmodule