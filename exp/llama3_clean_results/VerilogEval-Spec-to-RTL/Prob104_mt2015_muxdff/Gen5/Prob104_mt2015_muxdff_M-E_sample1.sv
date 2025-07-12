module TopModule (
    input clk,
    input L,
    input [1:0] bit_pos,
    input q_in,
    input q_in_2, // Input for the second bit calculation
    input r_in,
    output Q
);

reg q_reg;

always @(posedge clk) begin
    if (L) begin
        q_reg <= r_in;
    end else begin
        case (bit_pos)
            2'b00: begin // First bit
                q_reg <= q_in_2; // Assuming q_in_2 represents the input for the previous bit
            end
            2'b01: begin // Second bit
                q_reg <= q_in ^ q_in_2; // XOR of current and previous bits
            end
            2'b10: begin // Third bit
                q_reg <= q_in; // Remains the same
            end
            default: begin
                q_reg <= 1'b0; // Default case
            end
        endcase
    end
end

assign Q = q_reg;

endmodule