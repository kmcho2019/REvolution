module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    reg last_in;
    wire clk_enable;

    // Clock gating control - only enable when input changes
    assign clk_enable = (in != last_in) || !resetn;

    always @(posedge clk) begin
        last_in <= in;
    end

    always @(posedge clk) begin
        if (!clk_enable) begin
            // Clock gated - retain values
            shift_reg <= shift_reg;
        end
        else if (!resetn) begin
            shift_reg <= 4'b0;
        end
        else begin
            shift_reg <= {shift_reg[2:0], in};
        end
    end

    assign out = shift_reg[3];

endmodule