module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= 0;
    end else begin
        if ($time == 15) begin // first positive edge of clk
            q <= 1;
        end
    end
end

endmodule