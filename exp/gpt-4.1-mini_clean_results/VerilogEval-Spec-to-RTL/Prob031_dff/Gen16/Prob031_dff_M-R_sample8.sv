module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q   // q declared as reg to allow procedural assignment
);

    // Positive edge triggered D flip-flop
    always @(posedge clk) begin
        q <= d;
    end

endmodule