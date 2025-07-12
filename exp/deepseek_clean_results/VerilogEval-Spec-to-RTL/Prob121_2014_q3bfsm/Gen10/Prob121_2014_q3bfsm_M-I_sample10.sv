module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot encoded states (5 states)
    parameter S0 = 5'b00001;
    parameter S1 = 5'b00010;
    parameter S2 = 5'b00100;
    parameter S3 = 5'b01000;
    parameter S4 = 5'b10000;

    reg [4:0] state, next_state;

    // State transitions
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // State register and output pipeline
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end
        else begin
            state <= next_state;
            // Output is pipelined and simplified using one-hot properties
            z <= (state == S3) || (state == S4);
        end
    end

endmodule