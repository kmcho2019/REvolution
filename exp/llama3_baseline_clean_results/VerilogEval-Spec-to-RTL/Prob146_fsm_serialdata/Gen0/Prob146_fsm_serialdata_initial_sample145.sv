module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;

reg [2:0] state; // 0: IDLE, 1: RECEIVE_DATA, 2: VERIFY_STOP, 3: WAIT_FOR_STOP
reg [2:0] data_count; // count the number of data bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done_reg <= 0;
        out_byte_reg <= 0;
        data_count <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // RECEIVE_DATA
                    data_count <= 1;
                    out_byte_reg[0] <= 1; // least significant bit
                end else begin
                    state <= 0;
                end
            end
            1: begin // RECEIVE_DATA
                data_count <= data_count + 1;
                if (data_count == 8) begin // all 8 data bits received
                    state <= 2; // VERIFY_STOP
                end
                out_byte_reg[data_count-1] <= in;
            end
            2: begin // VERIFY_STOP
                if (in) begin // stop bit detected
                    done_reg <= 1;
                    state <= 0; // IDLE
                end else begin // stop bit not detected
                    state <= 3; // WAIT_FOR_STOP
                end
            end
            3: begin // WAIT_FOR_STOP
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                end
            end
            default: state <= 0;
        endcase
        if (state != 2) begin
            done_reg <= 0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule