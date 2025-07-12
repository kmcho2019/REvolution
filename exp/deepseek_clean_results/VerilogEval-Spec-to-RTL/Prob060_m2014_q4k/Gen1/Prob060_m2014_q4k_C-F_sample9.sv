module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    parameter WIDTH = 4;  // Parameterized for flexibility
    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= {WIDTH{1'b0}};  // Clear all bits
        end
        else begin
            shift_reg <= {shift_reg[WIDTH-2:0], in};  // Shift operation
        end
    end

    // Explicit output register for better timing if needed
    assign out = shift_reg[WIDTH-1];

endmodule