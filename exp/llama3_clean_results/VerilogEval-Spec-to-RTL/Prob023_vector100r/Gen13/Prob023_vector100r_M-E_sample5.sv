module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] shift_reg;

    always @(posedge in) begin
        shift_reg <= in;
    end

    always @(posedge shift_reg) begin
        out <= {shift_reg[0], shift_reg[1:WIDTH]};
    end

    // To reverse the bits, we need to shift the bits out of the shift register
    // in reverse order. We can do this by using a counter to keep track of the
    // current bit position, and then shifting the bits out of the shift register
    // based on the counter value.
    reg [WIDTH-1:0] counter;
    always @(posedge shift_reg) begin
        counter <= counter + 1;
        if (counter == WIDTH - 1) begin
            out <= shift_reg;
        end else begin
            out <= {shift_reg[WIDTH-1-counter], out[WIDTH-2:0]};
        end
    end

endmodule