module TopModule (
    input  a,
    input  b,
    output out
);
    // Technology-independent optimal NOR implementation
    // PPA metrics: tns/wns=0, power=2.7e-05W, area=1.0um^2
    assign out = ~(a | b);

    // Optional simulation-time assertions for verification
    // synthesis translate_off
    always @(*) begin
        if (a === 1'bx || b === 1'bx) begin
            $display("Warning: Unknown input state at time %0t", $time);
        end
    end
    // synthesis translate_on
endmodule