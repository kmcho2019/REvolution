module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

reg [1:0] state; // State machine: IDLE (2'b00), DATA_WAIT (2'b01), OUTPUT (2'b10)
reg [7:0] data_lock; // Register to hold the first valid data

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        valid_out <= 1'b0;
        data_out <= 16'd0;
        data_lock <= 8'd0;
    end
    else begin
        case (state)
            2'b00: // IDLE state
                if (valid_in) begin
                    data_lock <= data_in;
                    state <= 2'b01;
                end
            2'b01: // DATA_WAIT state
                if (valid_in) begin
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    state <= 2'b10;
                end
            2'b10: // OUTPUT state
                valid_out <= 1'b0;
                state <= 2'b00;
            default:
                state <= 2'b00;
        endcase
    end
end

endmodule