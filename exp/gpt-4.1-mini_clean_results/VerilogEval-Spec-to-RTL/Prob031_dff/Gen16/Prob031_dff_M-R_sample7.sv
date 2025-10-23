module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    // Direct D flip-flop implementation inside TopModule
    always @(posedge clk) begin
        q <= d;
    end

endmodule