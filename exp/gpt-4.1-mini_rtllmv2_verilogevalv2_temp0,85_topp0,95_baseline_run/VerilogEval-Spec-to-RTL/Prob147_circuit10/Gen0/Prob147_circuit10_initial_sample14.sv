module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    wire q_wire;

    assign q_wire = (state & ~(a & b)) | (b & ~state & ~a);
    assign q = q_wire;

    always @(posedge clk) begin
        state <= q_wire;
    end

endmodule