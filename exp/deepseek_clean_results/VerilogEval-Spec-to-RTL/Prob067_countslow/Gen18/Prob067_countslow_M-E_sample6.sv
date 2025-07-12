module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// State encoding - one-hot would be inefficient, so using binary
parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;
parameter S6 = 4'b0110;
parameter S7 = 4'b0111;
parameter S8 = 4'b1000;
parameter S9 = 4'b1001;

reg [3:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        S0: next_state = slowena ? S1 : S0;
        S1: next_state = slowena ? S2 : S1;
        S2: next_state = slowena ? S3 : S2;
        S3: next_state = slowena ? S4 : S3;
        S4: next_state = slowena ? S5 : S4;
        S5: next_state = slowena ? S6 : S5;
        S6: next_state = slowena ? S7 : S6;
        S7: next_state = slowena ? S8 : S7;
        S8: next_state = slowena ? S9 : S8;
        S9: next_state = slowena ? S0 : S9;
        default: next_state = S0;
    endcase
end

// State register with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Output assignment
always @(*) begin
    q = state;
end

endmodule