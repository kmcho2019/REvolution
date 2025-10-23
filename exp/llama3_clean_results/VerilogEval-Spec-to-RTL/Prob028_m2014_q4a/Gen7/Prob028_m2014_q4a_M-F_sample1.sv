module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena) begin
        q <= d;  // Capture d when ena is high
    end else begin
        // Implicitly hold q when ena is low; no explicit action needed here.
    end
end

endmodule