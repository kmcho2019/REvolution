module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// State encoding
localparam S4 = 3'd4;
localparam S5 = 3'd5;
localparam S6 = 3'd6;
localparam S0 = 3'd0;
localparam S1 = 3'd1;

always @(*) begin
    if (a) q = S4;  // Combinational override when a=1
end

always @(posedge clk) begin
    if (!a) begin
        case (q)
            S4: q <= S5;
            S5: q <= S6;
            S6: q <= S0;
            S0: q <= S1;
            S1: q <= S4;  // This case shouldn't occur since we reset to S4 when a=1
            default: q <= S4;
        endcase
    end
end

endmodule