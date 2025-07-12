module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

// Asynchronous reset
assign q = (ar)? 1'b0 : q;

// Clocked logic
always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

endmodule