// Define a module for the TopModule using a shift register approach
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

    // Define a generate block to instantiate the D flip-flops
    genvar i;
    logic [7:0] shift_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], d[0]};
        end
    end

    // Assign the output q to the current state of the shift register
    assign q = shift_reg;

endmodule