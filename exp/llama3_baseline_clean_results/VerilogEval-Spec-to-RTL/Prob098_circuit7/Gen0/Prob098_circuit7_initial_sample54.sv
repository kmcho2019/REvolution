module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= 0;
    end else begin
        if (~q) begin
            q <= 1;
        end
    end
end

initial begin
    q <= 1'b0; // Initialize q to a default value
end

endmodule