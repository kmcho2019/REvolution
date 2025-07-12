module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if(a) begin
        q <= ~q;  // Toggle q when a is 1
    end
end

initial begin
    q <= 1'b1;  // Initialize q to 1 on the first positive edge of the clock
end

endmodule