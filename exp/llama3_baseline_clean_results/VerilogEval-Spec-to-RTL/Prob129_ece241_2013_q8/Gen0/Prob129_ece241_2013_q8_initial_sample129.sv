module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

reg [1:0] state; // 3 states: 2'b00 (S0), 2'b01 (S1), 2'b10 (S2)

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // S0
                if (x) begin
                    state <= 2'b01; // Transition to S1
                    z <= 1'b0;
                end else begin
                    state <= 2'b00; // Stay in S0
                    z <= 1'b0;
                end
            end
            2'b01: begin // S1
                if (~x) begin
                    state <= 2'b10; // Transition to S2
                    z <= 1'b0;
                end else begin
                    state <= 2'b01; // Stay in S1
                    z <= 1'b0;
                end
            end
            2'b10: begin // S2
                if (x) begin
                    state <= 2'b01; // Transition back to S1 (recognized '101')
                    z <= 1'b1; // Assert z
                end else begin
                    state <= 2'b00; // Reset to S0
                    z <= 1'b0;
                end
            end
        endcase
    end
end

endmodule