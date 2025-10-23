module TopModule (
    input wire x,
    input wire y,
    output reg z
);

    always @(*) begin
        // Simple combinational comparison to get equality
        z = (x == y) ? 1'b1 : 1'b0;
    end

endmodule