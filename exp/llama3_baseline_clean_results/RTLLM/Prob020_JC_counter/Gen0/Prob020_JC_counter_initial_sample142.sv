module JC_counter(
    input  logic            clk,        // Clock signal
    input  logic            rst_n,      // Active-low reset signal
    output logic [63:0]     Q          // 64-bit register representing the current count value
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'd0;  // Reset the counter when rst_n is low
    end else begin
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]};  // Increment the counter when Q[0] is 0
        end else begin
            Q <= {1'b0, Q[63:1]};  // Decrement the counter when Q[0] is 1
        end
    end
end

endmodule