module TopModule(
    input clk,
    input a,
    output reg q
);

// Initial state
initial q = 1'b1;

// State transition logic and output q
always @(posedge clk) begin
    q <= (a) ? ~q : ~a;
end

endmodule