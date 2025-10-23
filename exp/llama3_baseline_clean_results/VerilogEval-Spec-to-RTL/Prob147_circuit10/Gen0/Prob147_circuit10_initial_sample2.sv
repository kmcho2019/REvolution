module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg [1:0] state
);

always @(posedge clk) begin
    if (a) begin
        state <= 1;
    end else begin
        state <= state;
    end
end

always @(*) begin
    if (state == 1) begin
        q <= ~b;
    end else begin
        q <= b;
    end
end

endmodule