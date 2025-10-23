module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q  // declared as reg to be assigned in always block
);

    always @(posedge clk) begin
        q = d;  // blocking assignment used intentionally for demonstration
    end

endmodule