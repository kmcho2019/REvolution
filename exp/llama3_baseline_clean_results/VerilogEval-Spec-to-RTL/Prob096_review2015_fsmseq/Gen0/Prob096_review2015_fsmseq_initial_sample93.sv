module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 3 bits to represent 6 states ( idle, s1, s2, s3, s4, found )

always @(posedge clk) begin
    if (reset) begin // Reset is active high
        state <= 0; // Reset to idle state
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data) begin
                    state <= 1; // Move to s1 if data is '1'
                end else begin
                    state <= 0; // Stay in idle if data is '0'
                end
            end
            1: begin // s1
                if (data) begin
                    state <= 2; // Move to s2 if data is '1'
                end else begin
                    state <= 0; // Reset to idle if data is '0'
                end
            end
            2: begin // s2
                if (~data) begin
                    state <= 3; // Move to s3 if data is '0'
                end else begin
                    state <= 1; // Move back to s1 if data is '1'
                end
            end
            3: begin // s3
                if (data) begin
                    state <= 4; // Move to s4 if data is '1'
                end else begin
                    state <= 0; // Reset to idle if data is '0'
                end
            end
            4: begin // s4
                state <= 5; // Move to found state
                start_shifting <= 1;
            end
            5: begin // found
                // Stay in found state until reset
                start_shifting <= 1;
            end
            default: state <= 0; // Reset to idle for any invalid state
        endcase
    end
end

endmodule