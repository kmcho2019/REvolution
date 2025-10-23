module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Define states
localparam [2:0] S4 = 3'd4,
                 S5 = 3'd5,
                 S6 = 3'd6,
                 S0 = 3'd0,
                 S1 = 3'd1;

always @(posedge clk) begin
    if (a) begin
        q <= S4;  // Reset to state 4 when a=1
    end else begin
        case (q)
            S4: q <= S5;
            S5: q <= S6;
            S6: q <= S0;
            S0: q <= S1;
            S1: q <= S4;  // Complete the cycle
            default: q <= S4;
        endcase
    end
end

endmodule