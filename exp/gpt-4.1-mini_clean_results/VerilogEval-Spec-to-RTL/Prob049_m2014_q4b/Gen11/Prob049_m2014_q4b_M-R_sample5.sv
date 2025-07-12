module TopModule (
    input clk,
    input ar,      // Asynchronous active-high reset
    input d,
    output reg q
);

reg q_int;

// Internal D flip-flop sampling 'd' on posedge clk
always @(posedge clk) begin
    q_int <= d;
end

// Output 'q' asynchronously driven to 0 on reset, else q_int
always @(*) begin
    if (ar)
        q = 1'b0;
    else
        q = q_int;
end

endmodule