module TopModule (
    input clk,
    input d,
    output reg q  // Output q stores the state of the D flip-flop
);

    // On each rising edge of clk, capture input d into q
    always @(posedge clk) begin
        q <= d;
    end

endmodule