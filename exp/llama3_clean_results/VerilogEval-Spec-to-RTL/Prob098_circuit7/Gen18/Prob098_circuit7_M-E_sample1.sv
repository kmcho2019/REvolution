module TopModule(
    input clk,
    input a,
    output reg q
);

// Initial output value
initial q = 1'b1;

// Toggle output q when a is high
always @(posedge clk) begin
    if (a) begin
        q <= ~q;
    end
end

endmodule