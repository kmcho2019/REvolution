module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Combinational signals for next state and carries
    wire carry_ones;
    wire carry_tens;
    wire carry_hundreds;

    wire [3:0] next_ones;
    wire [3:0] next_tens;
    wire [3:0] next_hundreds;
    wire [3:0] next_thousands;

    // Calculate next ones digit and carry
    assign {carry_ones, next_ones} = (ones == 4'd9) ? ({1'b1, 4'd0}) : ({1'b0, ones + 1'b1});

    // Calculate next tens digit and carry
    assign {carry_tens, next_tens} = carry_ones ?
                                    ((tens == 4'd9) ? ({1'b1, 4'd0}) : ({1'b0, tens + 1'b1}))
                                    : ({1'b0, tens});

    // Calculate next hundreds digit and carry
    assign {carry_hundreds, next_hundreds} = carry_tens ?
                                            ((hundreds == 4'd9) ? ({1'b1, 4'd0}) : ({1'b0, hundreds + 1'b1}))
                                            : ({1'b0, hundreds});

    // Calculate next thousands digit (rolls over at 9)
    assign next_thousands = carry_hundreds ?
                           ((thousands == 4'd9) ? 4'd0 : thousands + 1'b1)
                           : thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena       <= 3'b000;
            q         <= 16'd0;
        end else begin
            // Update digit registers
            ones      <= next_ones;
            tens      <= next_tens;
            hundreds  <= next_hundreds;
            thousands <= next_thousands;

            // Update ena to indicate increments of upper digits [3:1]
            // ena[2] = carry_hundreds (increment thousands)
            // ena[1] = carry_tens (increment hundreds)
            // ena[0] = carry_ones (increment tens)
            ena <= {carry_hundreds, carry_tens, carry_ones};

            // Assign q using updated digit registers to avoid lag
            q <= {next_thousands, next_hundreds, next_tens, next_ones};
        end
    end

endmodule