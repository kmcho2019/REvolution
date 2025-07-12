module TopModule(
    input d,
    input ena,
    output reg q
);

always @(ena or d) begin
    q <= q;        // default assignment to hold current state
    if (ena)
        q <= d;    // transparent when ena is high
end

endmodule