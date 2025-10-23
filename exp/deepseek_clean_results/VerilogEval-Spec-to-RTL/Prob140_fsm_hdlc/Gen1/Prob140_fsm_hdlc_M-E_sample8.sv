module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;
    wire disc_detect, flag_detect, err_detect;

    // Shift register to track last 7 bits
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            shift_reg <= {shift_reg[5:0], in};
            
            // Register outputs with 1-cycle delay
            disc <= disc_detect;
            flag <= flag_detect;
            err <= err_detect;
        end
    end

    // Combinational pattern detection
    assign disc_detect = (shift_reg == 7'b0111110);
    assign flag_detect = (shift_reg == 7'b1111110);
    assign err_detect = (shift_reg == 7'b1111111);

endmodule