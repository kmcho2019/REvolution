module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // Idle = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, Found = 3'b100

always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to Idle state
        start_shifting <= 0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                if (data) begin
                    state <= 3'b001; // Transition to S1 state
                end
            end
            3'b001: begin // S1 state
                if (data) begin
                    state <= 3'b010; // Transition to S2 state
                end else begin
                    state <= 3'b000; // Transition back to Idle state
                end
            end
            3'b010: begin // S2 state
                if (!data) begin
                    state <= 3'b011; // Transition to S3 state
                end else begin
                    state <= 3'b001; // Transition back to S1 state
                end
            end
            3'b011: begin // S3 state
                if (data) begin
                    state <= 3'b100; // Transition to Found state
                end else begin
                    state <= 3'b000; // Transition back to Idle state
                end
            end
            3'b100: begin // Found state
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule