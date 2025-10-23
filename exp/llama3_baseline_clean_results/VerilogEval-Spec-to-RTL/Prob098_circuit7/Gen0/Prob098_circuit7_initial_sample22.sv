module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if(a == 0) begin
        q <= 1;
    end else if(q == 1) begin
        q <= 1; // For the first cycle when a becomes 1, q remains 1
    end else begin
        q <= 0; // Subsequent cycles when a is 1, q stays 0
    end
end

endmodule