module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

    reg [N-1:0] res;  // N-bit register to store the result

    // Determine if the operands have the same sign (both positive or both negative)
    assign c = (a[N-1] == b[N-1]) ? 
                (a[N-1] ? ({1'b0, a[N-2:0]} + {1'b0, b[N-2:0]}) : ({1'b0, a[N-2:0]} + {1'b0, b[N-2:0]})) : 
                // If the signs are different, determine the larger absolute value
                ((a[N-2:0] > b[N-2:0]) && !a[N-1]) ? 
                    ({1'b0, a[N-2:0]} - {1'b0, b[N-2:0]}) : 
                ((b[N-2:0] > a[N-2:0]) && a[N-1]) ? 
                    ({1'b0, b[N-2:0]} - {1'b0, a[N-2:0]}) : 
                    // Otherwise, if a[N-1] is 1 and a[N-2:0] <= b[N-2:0]
                    (a[N-1] == 1) ? 
                        ({1'b1, b[N-2:0]} - {1'b1, a[N-2:0]}) : 
                        ({1'b0, b[N-2:0]} - {1'b0, a[N-2:0]}));

    // Check for overflow
    always @(*) begin
        if (c >= 2**N) begin
            $display("Overflow occurred!");
            // Handle overflow, e.g., by wrapping around or saturating
        end
    end

endmodule