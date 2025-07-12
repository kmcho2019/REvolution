module JC_counter (
    input clk, 
    input rst_n, 
    output reg [63:0] Q
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the counter to 0 on reset
        Q <= 64'd0;
    end else begin
        // Update the counter based on the LSB
        if (Q[0] == 1'b0) begin
            // Increment: shift right and append a 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement: shift right and append a 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule