module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [1:0] state = 2'b00; // Idle state

    always @(posedge clk) begin
        if (reset) begin // Reset is active high
            state = 2'b00; // Return to Idle state
            start_shifting = 1'b0;
        end else begin
            case (state)
                2'b00: begin // Idle
                    if (data) begin
                        state = 2'b01; // Move to S1
                    end
                end
                2'b01: begin // S1
                    if (data) begin
                        state = 2'b10; // Move to S2
                    end else begin
                        state = 2'b00; // Return to Idle
                    end
                end
                2'b10: begin // S2
                    if (~data) begin
                        state = 2'b11; // Move to S3
                    end else begin
                        state = 2'b01; // Stay in S1
                    end
                end
                2'b11: begin // S3
                    if (data) begin
                        state = 2'b00; // Sequence not found, return to Idle
                    end else begin
                        start_shifting = 1'b1; // Found sequence '1101', set start_shifting to 1
                    end
                end
                default: begin
                    start_shifting = 1'b1; // Stay in Found state, start_shifting remains 1
                end
            endcase
        end
    end
endmodule