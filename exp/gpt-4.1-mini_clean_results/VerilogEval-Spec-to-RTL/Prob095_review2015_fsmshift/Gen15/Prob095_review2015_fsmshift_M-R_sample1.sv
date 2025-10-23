module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b1111; // 4 cycles enabled
        end else begin
            shift_reg <= {1'b0, shift_reg[3:1]}; // shift right, insert 0
        end
    end

    assign shift_ena = shift_reg[0];

endmodule