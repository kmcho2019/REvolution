module TopModule(
    input         clk,
    input         reset,
    input  [7:0]  d,
    output [7:0] q
);

always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        q <= 8'd0; // Asynchronous reset
    end else begin
        q <= d; // D flip-flop behavior
    end
end

endmodule