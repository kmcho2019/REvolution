module TopModule (
    input  wire clk,
    input  wire L,
    input  wire q_in,
    input  wire r_in,
    output reg  Q
);

    // Pure synchronous implementation
    always @(posedge clk) begin
        Q <= L ? r_in : q_in;
    end

endmodule