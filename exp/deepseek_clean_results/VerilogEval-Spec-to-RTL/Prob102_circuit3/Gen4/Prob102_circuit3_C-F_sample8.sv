module TopModule (
    input a,    // First control signal
    input b,    // Second control signal
    input c,    // First data signal
    input d,    // Second data signal
    output q    // Output result
);

    // Internal signals with descriptive names
    wire any_control = a | b;  // True when either control signal is active
    wire any_data = c | d;     // True when either data signal is active

    // Output is active when:
    // - Any control signal is active (a OR b)
    // AND
    // - Any data signal is active (c OR d)
    assign q = any_control & any_data;

    // Simulation-time checks for X/Z values
    initial begin
        if ($test$plusargs("CHECK_VALID")) begin
            $display("TopModule: Input validity checking enabled");
            forever @(*) begin
                #1;
                if (^a === 1'bx || ^b === 1'bx || ^c === 1'bx || ^d === 1'bx) begin
                    $warning("TopModule: Detected X/Z value on inputs");
                end
            end
        end
    end

endmodule