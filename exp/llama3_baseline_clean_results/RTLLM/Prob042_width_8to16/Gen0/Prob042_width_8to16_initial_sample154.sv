module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;
reg [1:0] state;
reg [15:0] data_out_reg;

assign valid_out = (state == 2'b10);
assign data_out = data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        data_lock <= 8'b0;
        data_out_reg <= 16'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (valid_in) begin
                    data_lock <= data_in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // lock state
                if (valid_in) begin
                    data_out_reg <= {data_lock, data_in};
                    state <= 2'b10;
                end
            end
            2'b10: begin // output state
                state <= 2'b00;
            end
        endcase
    end
end

endmodule