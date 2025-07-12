module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

// State encoding
localparam STATE_0 = 1'b0;
localparam STATE_1 = 1'b1;

reg state;

always @(posedge clk) begin
    case (state)
        STATE_0: state <= (j) ? STATE_1 : (k ? STATE_0 : STATE_0);
        STATE_1: state <= (k) ? (j ? STATE_0 : STATE_0) : (j ? STATE_1 : STATE_1);
    endcase
end

assign Q = state;

endmodule