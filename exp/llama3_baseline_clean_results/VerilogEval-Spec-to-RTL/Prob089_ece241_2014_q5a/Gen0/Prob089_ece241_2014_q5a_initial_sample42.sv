module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0: IDLE, 1: RUNNING
reg carry; // carry flag
reg z_reg; // output register

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        carry <= 1'b0;
        z_reg <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~areset) begin
                    state <= 1;
                    carry <= 1'b1;
                end
            end
            1: begin // RUNNING
                if (areset) begin
                    state <= 0;
                    carry <= 1'b0;
                end else begin
                    z_reg <= x ^ carry;
                    carry <= x & carry;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule