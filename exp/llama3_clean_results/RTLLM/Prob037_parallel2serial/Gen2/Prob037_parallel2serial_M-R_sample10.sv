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
        state <= 2'b00;
        data_reg <= 4'b0;
    end else begin
        case (state)
            2'b00: begin // Load data and set valid
                data_reg <= d;
                state <= 2'b01;
            end
            2'b01: begin // Output MSB
                state <= 2'b10;
            end
            2'b10: begin // Output second bit
                state <= 2'b11;
            end
            2'b11: begin // Output third bit and prepare for last bit
                state <= 2'b00; // Reset state for next cycle
            end
        endcase
    end
end

assign valid_out = (state != 2'b00);
assign dout = data_reg[3];

always @(posedge clk) begin
    case (state)
        2'b01, 2'b10, 2'b11: begin
            data_reg <= {data_reg[2:0], 1'b0}; // Shift data
        end
    endcase
end

endmodule