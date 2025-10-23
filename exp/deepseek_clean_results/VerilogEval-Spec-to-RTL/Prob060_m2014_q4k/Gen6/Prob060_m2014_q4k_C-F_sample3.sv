module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    parameter WIDTH = 4;  // Allows easy modification of shift register length
    reg [WIDTH-1:0] shift_reg = 0;

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= {WIDTH{1'b0}};  // Vectorized reset
        end else begin
            shift_reg <= {shift_reg[WIDTH-2:0], in};  // Efficient shift operation
        end
    end

    assign out = shift_reg[WIDTH-1];  // Output from MSB

endmodule