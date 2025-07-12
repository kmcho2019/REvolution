module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

assign q = state;

always @(posedge clk) begin
    if (b) begin
        if (a)
            state <= ~state; // toggle state when a=1 and b=1
        else
            state <= 1'b0;   // reset state to 0 when a=0 and b=1
    end
    else begin
        state <= state;      // hold state when b=0
    end
end

endmodule