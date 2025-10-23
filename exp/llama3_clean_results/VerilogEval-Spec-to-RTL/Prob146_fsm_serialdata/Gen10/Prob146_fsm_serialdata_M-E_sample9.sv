module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_counter;
reg byte_received;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // IDLE
        shift_reg <= 8'b0;
        bit_counter <= 3'b000;
        out_byte <= 8'b0;
        done <= 0;
        byte_received <= 0;
    end
    else begin
        case(state)
            3'b000: begin // IDLE
                if (!in) begin
                    state <= 3'b001; // START_DETECT
                end
            end
            3'b001: begin // START_DETECT
                state <= 3'b010; // DATA_RECEIVE
            end
            3'b010: begin // DATA_RECEIVE
                shift_reg <= {shift_reg[6:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd8) begin
                    state <= 3'b011; // STOP_VERIFY
                end
            end
            3'b011: begin // STOP_VERIFY
                if (in) begin
                    byte_received <= 1;
                    out_byte <= shift_reg;
                end
                else begin
                    state <= 3'b100; // STOP_WAIT
                end
            end
            3'b100: begin // STOP_WAIT
                if (in) begin
                    state <= 3'b000; // IDLE
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (byte_received) begin
        done <= 1;
        byte_received <= 0;
    end
    else begin
        done <= 0;
    end
end

endmodule