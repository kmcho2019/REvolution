module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    reg last_in;
    wire clk_enable = (in != last_in);

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            last_in <= 1'b0;
        end
        else if (clk_enable) begin
            shift_reg <= {shift_reg[2:0], in};
            last_in <= in;
        end
    end

    assign out = shift_reg[3];

endmodule