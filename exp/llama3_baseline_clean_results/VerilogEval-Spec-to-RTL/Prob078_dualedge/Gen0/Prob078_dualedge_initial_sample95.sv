module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_int;

always @(posedge clk) begin
    q_int <= d;
end

always @(negedge clk) begin
    q <= q_int;
end

// or we can use a single always block like this
// always @(posedge clk or negedge clk) begin
//     if (clk) begin
//         q_int <= d;
//     end else begin
//         q <= q_int;
//     end
// end

endmodule