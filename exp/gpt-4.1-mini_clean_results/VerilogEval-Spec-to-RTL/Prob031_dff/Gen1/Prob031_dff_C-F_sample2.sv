module TopModule (
    input clk,
    input d,
    output reg q  // Output q stores the state of the D flip-flop
);

    // On every positive clock edge, update q with d
    always @(posedge clk) begin
        q <= d;
    end

endmodule