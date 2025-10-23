module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a != b) begin
        state <= ~state;
    end
    if (state == 1'b0) begin
        if (~a) begin
            q <= b;
        end
    end else begin
        q <= ~b;
    end
end

endmodule