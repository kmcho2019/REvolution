module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset process: asynchronously clear q when ar is high
always @(posedge ar) begin
    q <= 1'b0;
end

// Data capture process: on clock edge, latch d if reset not asserted
always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

endmodule