module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // Idle, Running
reg z_reg;
reg carry;

// State encoding
parameter IDLE = 2'b00;
parameter RUNNING = 2'b01;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        z_reg <= 1'b0;
        carry <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~areset) begin
                    state <= RUNNING;
                    z_reg <= ~x;
                    carry <= x;
                end
            end
            RUNNING: begin
                if (areset) begin
                    state <= IDLE;
                    z_reg <= 1'b0;
                    carry <= 1'b0;
                end else begin
                    z_reg <= ~(x ^ carry);
                    carry <= x & carry | x & ~z_reg | ~z_reg & carry;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule