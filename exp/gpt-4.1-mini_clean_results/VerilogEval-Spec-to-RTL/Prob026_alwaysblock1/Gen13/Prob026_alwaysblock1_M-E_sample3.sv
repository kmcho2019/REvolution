module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal wire implementing AND using a mux style: out = b ? a : 0
    wire and_via_mux = b ? a : 1'b0;

    // assign output driven by internal wire
    assign out_assign = and_via_mux;

    // combinational always block replicating the mux logic
    always @(*) begin
        if (b)
            out_alwaysblock = a;
        else
            out_alwaysblock = 1'b0;
    end

endmodule