module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);
    reg [3:0] shift_reg;
    reg in_d;

    always @(posedge clk) begin
        if (~resetn) begin
            shift_reg <= 4'b0000;
            in_d <= 1'b0;
        end else begin
            in_d <= in;
            // Shift only if input changes to reduce toggling
            if (in != in_d)
                shift_reg <= {shift_reg[2:0], in};
        end
    end

    assign out = shift_reg[3];

endmodule