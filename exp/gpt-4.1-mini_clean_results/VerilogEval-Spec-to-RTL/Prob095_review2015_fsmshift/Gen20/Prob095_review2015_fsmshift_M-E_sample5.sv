module TopModule (
    input  wire clk,
    input  wire reset,         // synchronous active high
    output wire shift_ena
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b1111;     // enable shift_ena for 4 cycles including reset cycle
        end else begin
            shift_reg <= {1'b0, shift_reg[3:1]}; // shift right by 1, zero-fill MSB
        end
    end

    assign shift_ena = |shift_reg;    // asserted if any bit in shift_reg is 1

endmodule