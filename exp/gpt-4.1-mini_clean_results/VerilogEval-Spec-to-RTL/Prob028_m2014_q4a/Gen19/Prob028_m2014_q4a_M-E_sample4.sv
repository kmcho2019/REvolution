module TopModule (
    input  wire d,
    input  wire ena,
    output wire q
);

    reg stored;

    // Always block: update stored value only if ena is high
    always @(d or ena) begin
        if (ena)
            stored = d;
        // else stored keeps its previous value, inferring latch
    end

    assign q = stored;

endmodule