module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Declare a 4-bit register to hold the shift register values
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            // Synchronous active-low reset: clear all bits
            shift_reg <= 4'b0;
        end else begin
            // Shift operation: move all bits right and insert new input
            shift_reg <= {shift_reg[2:0], in};
        end
    end

    // Output is the last bit of the shift register
    assign out = shift_reg[3];

endmodule