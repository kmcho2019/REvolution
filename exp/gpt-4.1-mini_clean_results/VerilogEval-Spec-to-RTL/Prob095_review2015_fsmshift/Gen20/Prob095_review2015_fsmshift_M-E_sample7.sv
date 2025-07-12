module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Load 4 ones on reset to enable shift_ena for 4 cycles
            shift_reg <= 4'b1111;
        end else begin
            // Shift right by one bit, inserting zero
            shift_reg <= {1'b0, shift_reg[3:1]};
        end
    end

    // shift_ena is high if any bit in shift_reg is high
    assign shift_ena = |shift_reg;

endmodule