module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state; // S0, S1, S2

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin // Asynchronous reset
        state <= 2'b00; // Reset to S0
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // S0
                if (x) begin
                    state <= 2'b01; // Move to S1
                end else begin
                    state <= 2'b00; // Stay in S0
                end
                z <= 1'b0;
            end
            2'b01: begin // S1
                if (x) begin
                    state <= 2'b01; // Stay in S1
                end else begin
                    state <= 2'b10; // Move to S2
                end
                z <= 1'b0;
            end
            2'b10: begin // S2
                if (x) begin
                    state <= 2'b10; // Stay in S2 and assert z
                    z <= 1'b1;
                end else begin
                    state <= 2'b01; // Move back to S1
                    z <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00;
                z <= 1'b0;
            end
        endcase
    end
end

endmodule