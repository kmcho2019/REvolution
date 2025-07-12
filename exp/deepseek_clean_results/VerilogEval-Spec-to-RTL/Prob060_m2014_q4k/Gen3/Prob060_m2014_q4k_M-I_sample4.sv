module TopModule (
    input clk,
    input resetn,
    input in,
    output reg out
);

    reg [3:0] shift_reg;
    reg last_in;
    wire clk_en;

    // Clock gating control
    assign clk_en = (in != last_in) || !resetn;

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            out <= 1'b0;
            last_in <= 1'b0;
        end
        else if (clk_en) begin
            shift_reg <= {shift_reg[2:0], in};
            out <= shift_reg[3];
            last_in <= in;
        end
    end

endmodule