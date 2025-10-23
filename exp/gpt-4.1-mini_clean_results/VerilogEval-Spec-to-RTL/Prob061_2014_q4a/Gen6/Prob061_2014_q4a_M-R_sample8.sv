module TopModule (
    input  wire clk,
    input  wire w,
    input  wire R,
    input  wire E,
    input  wire L,
    output reg  Q
);

    wire next_Q;

    assign next_Q = L ? R : (E ? w : Q);

    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule