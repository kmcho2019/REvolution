module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] accumulator; // Assuming 8-bit input for simplicity
reg [2:0] state; // Idle, Accumulate, Invert

always @(posedge clk or posedge areset) begin
    if (areset) begin
        accumulator <= 8'b0;
        state <= 3'b001; // Idle state
        z <= 1'b0;
    end else begin
        case (state)
            3'b001: begin // Idle state
                if (x) begin
                    accumulator[0] <= x;
                    state <= 3'b010; // Accumulate state
                end
            end
            3'b010: begin // Accumulate state
                accumulator <= {accumulator[6:0], x};
                if (x) begin
                    state <= 3'b100; // Invert state
                end
            end
            3'b100: begin // Invert state
                accumulator <= {accumulator[6:0], ~x};
                z <= ~x;
            end
        endcase
    end
end

endmodule