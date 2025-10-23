module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // Using 2 bits for encoding 4 states

always @(posedge clk) begin
    if (reset) begin // Active high synchronous reset
        state <= 0; // Reset to initial state
        start_shifting <= 0;
    end else begin
        case (state)
            2'b00: // S0
                if (data == 1'b1)
                    state <= 2'b01; // Move to S1 on '1'
                else
                    state <= 2'b00; // Stay in S0 on '0'
            2'b01: // S1
                if (data == 1'b1)
                    state <= 2'b10; // Move to S2 on '1'
                else
                    state <= 2'b00; // Reset to S0 on '0'
            2'b10: // S2
                if (data == 1'b0)
                    state <= 2'b11; // Move to S3 on '0'
                else
                    state <= 2'b00; // Reset to S0 on '1'
            2'b11: // S3
                if (data == 1'b1)
                    state <= 2'b11; // Stay in S3 (sequence found), set output
                else
                    state <= 2'b00; // Reset to S0 on '0'
            default:
                state <= 2'b00; // Default, should not reach here
        endcase
        if (state == 2'b11)
            start_shifting <= 1'b1;
        else if (reset)
            start_shifting <= 1'b0;
    end
end

endmodule