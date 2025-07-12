module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_state;

assign next_state = (j & ~k) ? 1'b1 : 
                    (~j & k) ? 1'b0 : 
                    (j & k) ? ~Q : Q;

always @(posedge clk) begin
    Q <= next_state;
end

endmodule