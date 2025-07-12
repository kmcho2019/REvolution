module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 2 bits for 4 states (0 to 3)

localparam IDLE = 2'b00,
          S1    = 2'b01,
          S2    = 2'b10,
          S4    = 2'b11; // Using S4 directly after S2 as no need for S3 explicitly

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= S1;
                end
            end
            S1: begin
                if (data) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (data) begin
                    state <= S2; // Wait for '0' to proceed to S4
                end else begin
                    state <= S4;
                    start_shifting <= 1;
                end
            end
            S4: begin
                // Stay in S4, keeping start_shifting high
            end
        endcase
    end
end

endmodule