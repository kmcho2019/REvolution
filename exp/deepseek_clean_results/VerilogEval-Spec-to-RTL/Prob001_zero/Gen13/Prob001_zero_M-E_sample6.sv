module TopModule (
    input clk,
    output reg zero
);
    always @(posedge clk) begin
        zero <= 1'b0;  // Synchronously drive zero output
    end
endmodule