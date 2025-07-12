module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    reg q_int;
    always @(posedge clk) begin
        q_int <= L? r_in : q_in;
    end

    assign Q = q_int;

endmodule