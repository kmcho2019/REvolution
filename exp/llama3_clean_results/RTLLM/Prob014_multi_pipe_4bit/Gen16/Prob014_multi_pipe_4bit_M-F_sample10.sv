module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_sum;
reg [2*size-1:0] final_product;

reg [1:0] state; // State machine states: 0 - Reset, 1 - Load, 2 - Multiply

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'd0; // Reset state
        partial_sum <= {2*size{1'b0}};
        final_product <= {2*size{1'b0}};
    end else begin
        case (state)
            2'd0: begin // Reset state
                state <= 2'd1; // Transition to load state
            end
            2'd1: begin // Load state
                state <= 2'd2; // Transition to multiply state
            end
            2'd2: begin // Multiply state
                // Perform multiplication for each bit position of the multiplier
                reg [2*size-1:0] temp_sum;
                temp_sum = {2*size{1'b0}};
                for (int i = 0; i < size; i++) begin
                    if (mul_b[i] == 1'b1) begin
                        temp_sum = temp_sum + (mul_a << i);
                    end
                end
                partial_sum <= temp_sum;
                final_product <= partial_sum;
                state <= 2'd0; // Transition back to reset state
            end
        endcase
    end
end

always @(posedge clk) begin
    mul_out <= final_product;
end

endmodule