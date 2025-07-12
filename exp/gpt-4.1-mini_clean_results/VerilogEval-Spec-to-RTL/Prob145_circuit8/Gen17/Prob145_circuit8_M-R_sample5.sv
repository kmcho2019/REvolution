module DFF (
    input clock,
    input d,
    output reg q
);
    always @(posedge clock) begin
        q <= d;
    end
endmodule

module TopModule (
    input clock,
    input a,
    output p,
    output q
);
    // First flip-flop: captures 'a' into 'p'
    wire p_wire, q_wire;

    DFF dff1 (.clock(clock), .d(a), .q(p_wire));
    // Second flip-flop: captures 'p' into 'q'
    DFF dff2 (.clock(clock), .d(p_wire), .q(q_wire));

    assign p = p_wire;
    assign q = q_wire;
endmodule