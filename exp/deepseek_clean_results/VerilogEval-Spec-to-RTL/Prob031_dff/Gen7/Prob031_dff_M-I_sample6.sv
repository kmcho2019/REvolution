(* keep_hierarchy = "true" *)
module TopModule (
    input clk,
    input d,
    output reg q
    // input rst_n  // Optional asynchronous reset (active low)
);

// Uncomment for asynchronous reset version:
// always @(posedge clk or negedge rst_n) begin
//     if (!rst_n) q <= 1'b0;
//     else        q <= d;
// end

(* clock_gating = "yes" *)
always @(posedge clk) begin
    q <= d;
end

endmodule