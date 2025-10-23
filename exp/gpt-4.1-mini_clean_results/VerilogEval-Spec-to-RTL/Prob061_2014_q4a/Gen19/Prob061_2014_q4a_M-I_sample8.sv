module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire enable = L | E;
    wire data_in = L ? R : w;

    always @(posedge clk) begin
        if (enable)
            Q <= data_in;
        // else Q retains its value (implicit)
    end

endmodule