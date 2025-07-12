module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg gated_clk;
wire [2:0] next_q;

// Clock gating
always @(*) begin
    gated_clk = clk & ~a;
end

// Next state logic
always @(*) begin
    case (q)
        3'd6: next_q = 3'd0;
        default: next_q = q + 3'd1;
    endcase
end

// State update with gated clock
always @(posedge gated_clk) begin
    q <= next_q;
end

// Initial state
initial begin
    q = 3'd4;
end

endmodule