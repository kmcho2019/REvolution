module TopModule (
    input clk,
    input resetn,
    input in,
    output reg out
);

    reg [3:0] shift_reg;
    wire [3:0] next_state;

    // Next state logic with circular feedback option
    assign next_state = {shift_reg[2:0], in}; // Standard shift operation

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            out <= 1'b0;
        end
        else begin
            shift_reg <= next_state;
            out <= shift_reg[3]; // Output the MSB (last stage)
        end
    end

endmodule