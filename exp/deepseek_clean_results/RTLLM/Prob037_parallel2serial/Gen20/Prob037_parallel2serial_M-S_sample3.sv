module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= (shift_reg == 4'b0) ? d : {shift_reg[2:0], 1'b0};
        end
    end

    assign valid_out = (shift_reg != 4'b0);
    assign dout = shift_reg[3];

endmodule