module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [1:0] state; // State machine state (idle, receiving, output)
reg [2:0] bit_cnt; // Bit counter
reg [7:0] shift_reg; // Shift register to store incoming serial data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset the circuit when rst_n is low
        state <= 2'd0; // Idle state
        bit_cnt <= 3'd0;
        shift_reg <= 8'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'd0;
    end else begin
        case (state)
            2'd0: begin // Idle state
                if (din_valid) begin // Transition to receiving state when input data is valid
                    state <= 2'd1;
                    bit_cnt <= 3'd1;
                    shift_reg <= {7'd0, din_serial};
                    dout_valid <= 1'd0;
                end else begin
                    state <= 2'd0; // Stay in idle state if input data is not valid
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                    dout_valid <= 1'd0;
                end
            end
            2'd1: begin // Receiving state
                if (bit_cnt == 3'd8) begin // Transition to output state when 8 bits have been received
                    state <= 2'd2;
                    dout_parallel <= shift_reg;
                    dout_valid <= 1'd1;
                end else if (din_valid) begin // Continue receiving state if input data is valid
                    bit_cnt <= bit_cnt + 1;
                    shift_reg <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'd0;
                end else begin
                    state <= 2'd1; // Stay in receiving state if input data is not valid
                    bit_cnt <= bit_cnt;
                    shift_reg <= shift_reg;
                    dout_valid <= 1'd0;
                end
            end
            2'd2: begin // Output state
                state <= 2'd0; // Transition back to idle state
                bit_cnt <= 3'd0;
                shift_reg <= 8'd0;
                dout_valid <= 1'd0;
            end
        endcase
    end
end

endmodule