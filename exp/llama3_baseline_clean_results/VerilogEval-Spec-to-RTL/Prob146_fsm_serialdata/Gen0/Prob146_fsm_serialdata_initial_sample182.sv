module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: ERROR
reg [2:0] next_state;
reg [7:0] data_reg; // register to hold the data bits
reg [3:0] bit_count_reg; // register to count the data bits

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0; // IDLE
        out_byte_reg <= 8'd0;
        done_reg <= 1'b0;
        data_reg <= 8'd0;
        bit_count_reg <= 4'd0;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state_reg <= 1; // START
                    bit_count_reg <= 4'd0;
                end else begin
                    state_reg <= 0; // stay in IDLE
                end
            end
            1: begin // START
                state_reg <= 2; // DATA
            end
            2: begin // DATA
                data_reg <= {data_reg[6:0], in}; // shift in the data bit
                bit_count_reg <= bit_count_reg + 1;
                if (bit_count_reg == 4'd7) begin
                    state_reg <= 3; // STOP
                end else begin
                    state_reg <= 2; // stay in DATA
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    out_byte_reg <= data_reg;
                    done_reg <= 1'b1;
                    state_reg <= 0; // IDLE
                end else begin
                    state_reg <= 4; // ERROR
                end
            end
            4: begin // ERROR
                if (in) begin // stop bit detected
                    state_reg <= 0; // IDLE
                end else begin
                    state_reg <= 4; // stay in ERROR
                end
            end
            default: state_reg <= 0; // default to IDLE
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;
endmodule