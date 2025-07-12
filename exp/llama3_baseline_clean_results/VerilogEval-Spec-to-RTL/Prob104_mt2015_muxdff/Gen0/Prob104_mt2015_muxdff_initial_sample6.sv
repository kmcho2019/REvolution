module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    reg state;

    always @(posedge clk) begin
        if (L) begin
            state <= q_in;
        end else begin
            state <= state ^ r_in;
        end
    end

    assign Q = state;

endmodule