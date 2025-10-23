module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

// Internal active-low asynchronous reset signal
wire arst_n = ~ar;

always @(posedge clk or negedge arst_n) begin
    if (!arst_n) begin
        q <= 1'b0;   // async reset (active low)
    end else begin
        q <= d;      // capture data at clock edge
    end
end

endmodule