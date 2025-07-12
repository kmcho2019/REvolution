module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

// State definitions
parameter S0 = 8'b00000001;
parameter S1 = 8'b00000010;
parameter S2 = 8'b00000100;
parameter S3 = 8'b00001000;
parameter S4 = 8'b00010000;
parameter S5 = 8'b00100000;
parameter S6 = 8'b01000000;
parameter S7 = 8'b10000000;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= S0;  // Initialize to first state
    end
    else begin
        case (out)
            S0: out <= S1;
            S1: out <= S2;
            S2: out <= S3;
            S3: out <= S4;
            S4: out <= S5;
            S5: out <= S6;
            S6: out <= S7;
            S7: out <= S0;
            default: out <= S0;  // Handle undefined states
        endcase
    end
end

endmodule