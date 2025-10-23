module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a) begin
        q <= 0;
    end else if (b) begin
        q <= ~state;
    end
    
    state <= q;
end

endmodule