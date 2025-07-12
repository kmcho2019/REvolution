module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (!a) begin
        if (b) begin
            state <= !state;
        end
    end else begin
        state <= !state;
    end
end

assign q = (a)? state : b;

endmodule