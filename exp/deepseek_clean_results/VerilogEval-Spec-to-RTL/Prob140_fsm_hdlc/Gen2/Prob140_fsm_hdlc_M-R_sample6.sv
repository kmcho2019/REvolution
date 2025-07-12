module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    reg [6:0] shift_reg;
    reg disc_reg, flag_reg, err_reg;

    // Shift register to track last 7 bits (including current)
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0000000;
        end else begin
            shift_reg <= {shift_reg[5:0], in};
        end
    end

    // Pattern detection (combinational)
    wire disc_next = (shift_reg == 7'b00111110);  // 0111110
    wire flag_next = (shift_reg == 7'b01111110);  // 01111110
    wire err_next  = (&shift_reg[6:0]);           // 1111111 (7+ 1s)

    // Output registration (one cycle delay)
    always @(posedge clk) begin
        if (reset) begin
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg  <= 1'b0;
        end else begin
            disc_reg <= disc_next;
            flag_reg <= flag_next;
            err_reg  <= err_next;
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule