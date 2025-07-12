module TopModule (
    input  wire d,
    input  wire ena,
    output reg  q
);

    always @(d or ena) begin
        if (ena)
            q = d;
        // else, q is left unassigned to infer latch behavior
    end

endmodule