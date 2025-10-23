module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] state;
reg [3:0] shift_reg;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 4'b0000;
        shift_reg <= 4'b0000;
    end else begin
        case (state)
            4'b0000: begin
                shift_reg[0] <= in;
                state <= 4'b0001;
            end
            4'b0001: begin
                shift_reg[1] <= shift_reg[0];
                shift_reg[0] <= in;
                state <= 4'b0010;
            end
            4'b0010: begin
                shift_reg[2] <= shift_reg[1];
                shift_reg[1] <= shift_reg[0];
                shift_reg[0] <= in;
                state <= 4'b0011;
            end
            4'b0011: begin
                shift_reg[3] <= shift_reg[2];
                shift_reg[2] <= shift_reg[1];
                shift_reg[1] <= shift_reg[0];
                shift_reg[0] <= in;
                state <= 4'b0000;
            end
            default: begin
                state <= 4'b0000;
                shift_reg <= 4'b0000;
            end
        endcase
    end
end

assign out = shift_reg[3];

endmodule