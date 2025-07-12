module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// State definitions
localparam S4 = 3'd4;
localparam S5 = 3'd5;
localparam S6 = 3'd6;
localparam S0 = 3'd0;
localparam S1 = 3'd1;

always @(posedge clk) begin
    if (a) begin
        q <= S4;  // Reset to state 4 when a is high
    end else begin
        case (q)
            S4: q <= S5;
            S5: q <= S6;
            S6: q <= S0;
            S0: q <= S1;
            S1: q <= S4;  // Optional: could also stay at S1
            default: q <= S4;
        endcase
    end
end

endmodule