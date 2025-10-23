module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case (state)
            2'b01: begin // State A
                if (x == 1'b0) begin
                    state <= 2'b01; // Stay in state A
                    z <= 1'b0;
                end else begin
                    state <= 2'b10; // Go to state B
                    z <= 1'b1;
                end
            end
            2'b10: begin // State B
                if (x == 1'b0) begin
                    state <= 2'b10; // Stay in state B
                    z <= 1'b1;
                end else begin
                    state <= 2'b10; // Stay in state B
                    z <= 1'b0;
                end
            end
            default: state <= 2'b01; // Default to state A
        endcase
    end
end

endmodule