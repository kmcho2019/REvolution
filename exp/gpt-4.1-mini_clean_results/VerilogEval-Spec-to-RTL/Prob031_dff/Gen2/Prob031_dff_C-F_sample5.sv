module TopModule (
    input clk,
    input d,
    output reg q  // Output q holds the current state of the D flip-flop
);

    // On the rising edge of clk, capture input d into q
    always @(posedge clk) begin
        q <= d;
    end

endmodule