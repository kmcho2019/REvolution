module TopModule(
    input  a,
    input  b,
    output out
);
    // Optimal continuous assignment implementation
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