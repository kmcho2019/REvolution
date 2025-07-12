module TopModule (
    input  clk,
    input  d,
    input  r,
    output q
);

// One-hot state encoding (only 1 bit actually needed)
reg state;
localparam S0 = 1'b0;
localparam S1 = 1'b1;

always @(posedge clk) begin
    case (state)
        S0: state <= r ? S0 : (d ? S1 : S0);
        S1: state <= r ? S0 : (d ? S1 : S0);
        default: state <= S0; // Safe default
    endcase
end

assign q = state;

endmodule