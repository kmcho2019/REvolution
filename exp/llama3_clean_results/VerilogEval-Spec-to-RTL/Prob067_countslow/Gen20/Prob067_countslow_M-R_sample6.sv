module TopModule(
    input       clk,
    input       reset,
    input       slowena,
    output [3:0] q
);

reg [3:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0;
    end else if (slowena) begin
        state <= (state == 4'd9)? 4'b0 : state + 4'b1;
    end
end

assign q = state;

endmodule