module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] shift_reg;
    wire [3:0] next_shift_reg;

    // Next state logic
    assign next_shift_reg = reset ? 4'b1111 : {shift_reg[2:0], 1'b0};

    // Output logic
    assign shift_ena = shift_reg[3];

    // Register update
    always @(posedge clk) begin
        shift_reg <= next_shift_reg;
    end

endmodule