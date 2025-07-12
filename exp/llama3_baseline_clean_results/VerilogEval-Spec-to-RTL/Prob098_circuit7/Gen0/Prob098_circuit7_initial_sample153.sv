module TopModule(
    input clk,
    input a,
    output reg q
);

initial q = 1'b0; // Initialize q to 0

always @(posedge clk) begin
    if (a == 1'b0 && $time == 5) begin // At first positive edge when a is 0, set q to 1
        q <= 1'b1;
    end else if (a == 1'b1) begin
        q <= ~q; // Toggle q when a is 1 at the positive edge
    end
end

endmodule