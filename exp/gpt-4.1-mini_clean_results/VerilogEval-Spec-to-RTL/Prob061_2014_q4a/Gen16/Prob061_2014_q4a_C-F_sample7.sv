module TopModule (
    input  wire clk,
    input  wire w,
    input  wire R,
    input  wire E,
    input  wire L,
    output reg  Q
);

    always @(posedge clk) begin
        Q <= L ? R : (E ? w : Q);
    end

endmodule