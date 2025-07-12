module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [1:0] state;
reg [3:0] data_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        data_reg <= 0;
    end else begin
        case (state)
            0: begin
                data_reg <= d;
                state <= 1;
                valid_out <= 1'b1;
            end
            1: begin
                state <= 2;
                valid_out <= 1'b0;
            end
            2: begin
                state <= 3;
                valid_out <= 1'b0;
            end
            3: begin
                state <= 0;
                valid_out <= 1'b0;
            end
            default: state <= 0;
        endcase
    end
end

always @(*) begin
    case (state)
        0: dout = data_reg[3];
        1: dout = data_reg[2];
        2: dout = data_reg[1];
        3: dout = data_reg[0];
        default: dout = 1'bx;
    endcase
end

endmodule