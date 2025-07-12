module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    reg q_int;

    always @(posedge clk) begin
        q_int <= d;
    end

    assign q = q_int;

endmodule