module DFF_invert (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= ~d; // inversion performed inside sequential block
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    wire q_internal;
    DFF_invert dff_inst (
        .clk(clk),
        .d(a),
        .q(q_internal)
    );

    assign q = q_internal; // output directly from registered internal signal
endmodule