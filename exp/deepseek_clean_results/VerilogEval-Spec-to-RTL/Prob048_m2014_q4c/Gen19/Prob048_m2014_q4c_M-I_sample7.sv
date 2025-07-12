module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q = 1'b0  // Explicit initialization for synthesis
);

(* use_dsp48 = "no" *)  // Prevent unnecessary DSP usage
always @(posedge clk) begin
    if (r) begin
        q = 1'b0;  // Blocking assignment during reset for potential power savings
    end else begin
        q <= d;    // Non-blocking for normal operation
    end
end

endmodule