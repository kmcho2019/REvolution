module DFF (
    input clk,
    input D,
    output reg Q
);
    always @(posedge clk) begin
        Q <= D;
    end
endmodule

module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    wire D = L ? r_in : q_in;

    DFF dff_inst (
        .clk(clk),
        .D(D),
        .Q(Q)
    );
endmodule