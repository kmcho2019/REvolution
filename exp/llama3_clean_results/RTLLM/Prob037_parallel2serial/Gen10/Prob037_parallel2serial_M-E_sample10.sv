module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [1:0] state;
reg [3:0] data_reg;
reg valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        data_reg <= 4'b0;
        valid_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                data_reg <= d;
                valid_reg <= 1'b1;
                state <= 2'b01;
            end
            2'b01: begin
                valid_reg <= 1'b1;
                state <= 2'b10;
            end
            2'b10: begin
                valid_reg <= 1'b1;
                state <= 2'b11;
            end
            2'b11: begin
                valid_reg <= 1'b0;
                state <= 2'b00;
            end
        endcase
    end
end

assign valid_out = valid_reg;
assign dout = data_reg[3];

always @(posedge clk) begin
    case (state)
        2'b01: data_reg <= {data_reg[2:0], 1'b0};
        2'b10: data_reg <= {data_reg[2:0], 1'b0};
        2'b11: data_reg <= {data_reg[2:0], 1'b0};
    endcase
end

endmodule