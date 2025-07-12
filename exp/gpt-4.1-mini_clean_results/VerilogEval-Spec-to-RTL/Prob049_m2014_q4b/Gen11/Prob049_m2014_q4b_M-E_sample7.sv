module TopModule (
    input clk,
    input ar,      // Asynchronous active-high reset
    input d,
    output q
);

reg q_reg;

// Asynchronous reset block controls q_reg directly on reset assertion
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q_reg <= 1'b0;      // Reset state
    end else begin
        q_reg <= d;         // Capture data on clock edge
    end
end

// Continuous assignment of internal state to output
assign q = q_reg;

endmodule