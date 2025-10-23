module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;

reg [2:0] state_reg; // 3 states: IDLE (0), START_BIT (1), DATA_BITS (2), STOP_BIT (3), ERROR (4)
reg [2:0] state_next;

reg [3:0] data_bit_counter;

always @(*) begin
    case(state_reg)
        3'd0: // IDLE
            if (~in) begin
                state_next = 3'd1; // START_BIT
            end else begin
                state_next = 3'd0; // IDLE
            end
        3'd1: // START_BIT
            state_next = 3'd2; // DATA_BITS
        3'd2: // DATA_BITS
            if (data_bit_counter == 4'd7) begin
                state_next = 3'd3; // STOP_BIT
            end else begin
                state_next = 3'd2; // DATA_BITS
            end
        3'd3: // STOP_BIT
            if (in) begin
                state_next = 3'd0; // IDLE
                done_reg = 1'b1;
            end else begin
                state_next = 3'd4; // ERROR
            end
        3'd4: // ERROR
            if (in) begin
                state_next = 3'd0; // IDLE
            end else begin
                state_next = 3'd4; // ERROR
            end
        default:
            state_next = 3'd0; // IDLE
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 3'd0; // IDLE
        data_bit_counter <= 4'd0;
        done_reg <= 1'b0;
        out_byte_reg <= 8'd0;
    end else begin
        state_reg <= state_next;
        if (state_reg == 3'd2) begin // DATA_BITS
            if (data_bit_counter == 4'd0) begin
                out_byte_reg <= {7'd0, in};
            end else begin
                out_byte_reg <= {out_byte_reg[6:0], in};
            end
            data_bit_counter <= data_bit_counter + 1'b1;
        end else if (state_reg == 3'd3) begin // STOP_BIT
            data_bit_counter <= 4'd0;
            done_reg <= 1'b0;
        end else if (state_reg == 3'd4) begin // ERROR
            if (in) begin
                data_bit_counter <= 4'd0;
            end
        end else if (state_reg == 3'd0) begin // IDLE
            data_bit_counter <= 4'd0;
        end
        if (state_next == 3'd0 && state_reg == 3'd3) begin
            done_reg <= 1'b1;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule