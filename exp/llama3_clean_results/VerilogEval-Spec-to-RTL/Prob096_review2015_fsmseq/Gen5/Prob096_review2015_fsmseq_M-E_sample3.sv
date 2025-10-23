module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // 3-bit state register for states S0 to S4

// State machine logic
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to S0
        start_shifting <= 0;
    end else begin
        case (state)
            3'b000: // S0
                if (data == 1'b1) begin
                    state <= 3'b001; // Transition to S1 on '1'
                end
            3'b001: // S1
                if (data == 1'b1) begin
                    state <= 3'b010; // Transition to S2 on '1' after '1'
                end else begin
                    state <= 3'b000; // Reset to S0 on '0'
                end
            3'b010: // S2
                if (data == 1'b0) begin
                    state <= 3'b011; // Transition to S3 on '0' after '11'
                end else begin
                    state <= 3'b000; // Reset to S0 on '1' after '11'
                end
            3'b011: // S3
                if (data == 1'b1) begin
                    state <= 3'b100; // Transition to S4 on '1' after '110'
                end else begin
                    state <= 3'b000; // Reset to S0 on '0' after '110'
                end
            3'b100: // S4
                start_shifting <= 1; // Set start_shifting to 1 in S4
        endcase
    end
end

endmodule