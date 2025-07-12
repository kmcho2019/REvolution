module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Positive-edge flip-flop output
reg q_neg;  // Negative-edge flip-flop output

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Use a multiplexer for output selection
reg sel;
assign sel = clk;
always @(*) begin
    case(sel)
        1'b0: q = q_neg;
        1'b1: q = q_pos;
    endcase
end

endmodule