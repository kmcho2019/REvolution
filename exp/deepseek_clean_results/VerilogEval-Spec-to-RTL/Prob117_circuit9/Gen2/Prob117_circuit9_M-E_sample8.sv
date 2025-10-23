module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Define states
localparam [2:0] S0 = 3'd0,
                 S1 = 3'd1,
                 S2 = 3'd2,
                 S3 = 3'd3,
                 S4 = 3'd4,
                 S5 = 3'd5,
                 S6 = 3'd6;

// Initialize to state 4 (matches waveform)
initial begin
    q = S4;
end

always @(posedge clk) begin
    case (q)
        S0: q <= a ? S0 : S1;
        S1: q <= a ? S1 : S2;
        S2: q <= a ? S2 : S3;
        S3: q <= a ? S3 : S4;
        S4: q <= a ? S4 : S5;
        S5: q <= a ? S5 : S6;
        S6: q <= a ? S6 : S0;
        default: q <= S4;
    endcase
end

endmodule