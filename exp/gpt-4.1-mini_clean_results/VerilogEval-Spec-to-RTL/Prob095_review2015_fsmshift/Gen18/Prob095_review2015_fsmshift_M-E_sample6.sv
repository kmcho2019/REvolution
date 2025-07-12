module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Load 4 cycles of enable on reset
            shift_reg <= 4'b1111;
        end else begin
            // Shift right by 1, introducing zero at MSB
            shift_reg <= {1'b0, shift_reg[3:1]};
        end

        // Output is current LSB of shift register
        shift_ena <= shift_reg[0];
    end

endmodule