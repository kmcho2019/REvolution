module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if(a && b) begin
        state <= 0;
    end else if(!b && !a) begin
        state <= state;
    end else if(b && !a) begin
        state <= state;
    end else if(!b && a) begin
        state <= 1;
    end
end

always @(*) begin
    if(!state && b) begin
        q = 1;
    end else begin
        q = 0;
    end
end

endmodule