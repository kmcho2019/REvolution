module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] shift_reg;
reg [1:0] state;
reg valid_out;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        shift_reg <= 4'b0;
        valid_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                shift_reg <= d;
                state <= 2'b01;
                valid_out <= 1'b1;
            end
            2'b01: begin
                shift_reg <= {shift_reg[2:0], 1'b0};
                state <= 2'b10;
                valid_out <= 1'b1;
            end
            2'b10: begin
                shift_reg <= {shift_reg[2:0], 1'b0};
                state <= 2'b11;
                valid_out <= 1'b1;
            end
            2'b11: begin
                shift_reg <= {shift_reg[2:0], 1'b0};
                state <= 2'b00;
                valid_out <= 1'b0;
            end
        endcase
    end
end

assign dout = shift_reg[3];

endmodule