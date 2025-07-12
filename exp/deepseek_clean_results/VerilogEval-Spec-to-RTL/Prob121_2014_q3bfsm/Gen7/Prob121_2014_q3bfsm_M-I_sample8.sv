module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding parameters
    parameter S0 = 5'b00001;
    parameter S1 = 5'b00010;
    parameter S2 = 5'b00100;
    parameter S3 = 5'b01000;
    parameter S4 = 5'b10000;

    reg [4:0] state;

    // State transitions with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end
        else begin
            case (1'b1) // Synthesis will optimize this for one-hot
                state[0]: state <= x ? S1 : S0;  // S0
                state[1]: state <= x ? S4 : S1;  // S1
                state[2]: state <= x ? S1 : S2;  // S2
                state[3]: state <= x ? S2 : S1;  // S3
                state[4]: state <= x ? S4 : S3;  // S4
            endcase
            
            // Registered output
            z <= (state == S3) || (state == S4);
        end
    end

endmodule