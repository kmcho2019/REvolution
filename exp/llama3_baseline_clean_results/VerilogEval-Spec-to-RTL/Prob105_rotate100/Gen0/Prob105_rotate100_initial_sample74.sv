module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        // Load data into the register when load is high
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: begin
                // Rotate right by one bit
                q_reg <= {q_reg[0], q_reg[99:1]};
            end
            2'b10: begin
                // Rotate left by one bit
                q_reg <= {q_reg[98:0], q_reg[99]};
            end
            default: begin
                // No rotation for ena == 2'b00 or 2'b11
                q_reg <= q_reg;
            end
        endcase
    end
end

assign q = q_reg;

endmodule