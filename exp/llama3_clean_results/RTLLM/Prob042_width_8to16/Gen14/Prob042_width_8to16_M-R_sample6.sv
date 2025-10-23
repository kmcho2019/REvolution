module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [1:0] state; // 2 states: IDLE (0), LOCKED (1)
reg [7:0] data_lock;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // IDLE
        data_lock <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (valid_in) begin
                    data_lock <= data_in;
                    state <= 2'b01; // LOCKED
                end
            end
            2'b01: begin // LOCKED
                if (valid_in) begin
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    state <= 2'b00; // IDLE
                end
            end
            default: state <= 2'b00; // IDLE
        endcase
    end
end

always @(*) begin
    if (state == 2'b01 && valid_in) begin
        valid_out = 1'b1;
    end else begin
        valid_out = 1'b0;
    end
end

endmodule