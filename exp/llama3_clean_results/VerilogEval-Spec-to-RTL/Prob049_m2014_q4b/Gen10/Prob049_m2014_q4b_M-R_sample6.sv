module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

// Asynchronous reset handled through continuous assignment
assign q = ar? 1'b0 : q;

// Synchronous operation based on the clock edge
always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

endmodule