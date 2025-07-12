module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= 0;
    end else if (!a) begin
        if(q == 0) begin
            q <= 1;
        end
    end
end

endmodule