module TopModule(
    input clk,
    input a,
    output reg q
);

// Initialize q to 1
initial q = 1'b1;

// State transition logic using a D flip-flop
always @(posedge clk) begin
    q <= ~a;
end

endmodule