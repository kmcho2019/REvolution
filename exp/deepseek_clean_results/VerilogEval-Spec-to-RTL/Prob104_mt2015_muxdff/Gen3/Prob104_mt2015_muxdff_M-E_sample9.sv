module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    always @(posedge clk) begin
        case (L)
            1'b1: Q <= r_in;
            1'b0: Q <= q_in;
        endcase
    end

endmodule