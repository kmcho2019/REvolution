module JC_counter(
    input   logic           clk,            // Clock signal
    input   logic           rst_n,          // Active-low reset signal
    output  logic [63:0]    Q               // 64-bit register representing the current count value
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Asynchronous reset
        Q <= 64'd0;    // Reset Q to 0
    end else begin
        if (Q[0] == 1'b0) begin  // Increment
            Q <= {1'b1, Q[63:1]};  // Shift Q[63:1] to the right and append 1
        end else begin
            Q <= {1'b0, Q[63:1]};  // Shift Q[63:1] to the right and append 0
        end
    end
end

endmodule