module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state; // 2-bit state register to represent 3 states (S0, S1, S2)
localparam S0 = 2'b00; // Initial state
localparam S1 = 2'b01; // Waiting for '0' after first '1'
localparam S2 = 2'b10; // Waiting for final '1'

always @(posedge clk, negedge aresetn) begin
    if (~aresetn) begin // Asynchronous reset
        state <= S0;
        z <= 1'b0;
    end else begin
        case (state)
            S0: begin
                if (x) begin // If input is '1', move to S1
                    state <= S1;
                    z <= 1'b0;
                end else begin // Stay in S0 if input is '0'
                    state <= S0;
                    z <= 1'b0;
                end
            end
            S1: begin
                if (~x) begin // If input is '0', move to S2
                    state <= S2;
                    z <= 1'b0;
                end else begin // If input is '1', go back to S1
                    state <= S1;
                    z <= 1'b0;
                end
            end
            S2: begin
                if (x) begin // If input is '1', sequence detected, assert z
                    state <= S1; // Move back to S1 to recognize overlapping sequences
                    z <= 1'b1;
                end else begin // If input is '0', go back to S0
                    state <= S0;
                    z <= 1'b0;
                end
            end
            default: begin // Default case to avoid latches
                state <= S0;
                z <= 1'b0;
            end
        endcase
    end
end

endmodule