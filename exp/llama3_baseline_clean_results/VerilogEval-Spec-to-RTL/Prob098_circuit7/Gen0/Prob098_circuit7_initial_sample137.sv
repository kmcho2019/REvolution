module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= 0; // when 'a' is 1, 'q' is set to 0
    end else begin
        if (~q) begin
            q <= 1; // when 'a' is 0 and 'q' is 0, set 'q' to 1
        end
    end
end

endmodule