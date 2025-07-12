module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: ERROR
reg [7:0] data; // received data bits
reg [2:0] bit_count; // counter for data bits
reg data_valid; // flag for valid data
reg done_reg; // register for output done

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 0; // IDLE
        data <= 8'b0;
        bit_count <= 3'b0;
        data_valid <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // start bit detected
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // DATA
            end
            2: begin // DATA
                data[bit_count] <= in; // collect data bit
                bit_count <= bit_count + 1;
                if (bit_count == 7) begin // all data bits received
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // stop bit verified
                    data_valid <= 1'b1;
                    done_reg <= 1'b1;
                    state <= 0; // IDLE
                end else begin // stop bit not verified
                    state <= 4; // ERROR
                end
            end
            4: begin // ERROR
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // default to IDLE
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if (reset) begin
        done_reg <= 1'b0;
    end else if (data_valid) begin
        data_valid <= 1'b0;
    end
end

endmodule