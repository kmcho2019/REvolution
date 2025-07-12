module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Clock edge detector
reg clk_edge;
always @(posedge clk or negedge clk) begin
    if (clk) begin
        clk_edge <= 1'b1;
    end else begin
        clk_edge <= 1'b0;
    end
end

// Basic latch
reg latch_q;
always @(posedge ar or posedge clk_edge) begin
    if (ar) begin
        latch_q <= 1'b0; // Asynchronous reset
    end else if (clk_edge) begin
        latch_q <= d; // Update on positive clock edge
    end
end

// Output assignment
always @(*) begin
    if (ar) begin
        q = 1'b0; // Asynchronous reset
    end else begin
        q = latch_q;
    end
end

endmodule