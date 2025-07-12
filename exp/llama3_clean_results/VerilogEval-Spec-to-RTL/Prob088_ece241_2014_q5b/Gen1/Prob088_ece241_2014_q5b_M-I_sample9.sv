module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // State register

// One-hot encoding: A = 2'b01, B = 2'b10

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case(state)
            2'b01: begin // State A
                if (x == 1'b0) begin
                    state <= 2'b01; // Stay in A
                end else begin
                    state <= 2'b10; // Move to B
                end
            end
            2'b10: begin // State B
                state <= 2'b10; // Stay in B
            end
            default: begin // Invalid state, reset to A
                state <= 2'b01;
            end
        endcase
    end
end

assign z = (state == 2'b01 && x == 1'b1) || (state == 2'b10 && x == 1'b0);

endmodule