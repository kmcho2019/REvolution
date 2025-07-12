module TopModule(
    input  d,
    input  ena,
    output reg q
);
    always @(*) begin
        if (ena)
            q <= d;    // latch transparent when enable is high
        // else no assignment: latch holds previous q value implicitly
    end
endmodule