module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

always @(*) begin
    if (b == 1'b0) begin
        next_state = state;         // hold state if b=0
    end else begin
        if (a == 1'b0)
            next_state = ~state;    // toggle if b=1 and a=0
        else
            next_state = 1'b0;      // reset if b=1 and a=1
    end
end

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 1'b0;
end

endmodule