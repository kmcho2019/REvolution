module TopModule(
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // IDLE, START_BIT, DATA_BITS, STOP_BIT
reg [2:0] data_bits_counter;
reg [7:0] byte;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1; // START_BIT
                end
            end
            1: begin // START_BIT
                state <= 2; // DATA_BITS
                data_bits_counter <= 0;
                byte <= 0;
            end
            2: begin // DATA_BITS
                byte <= {byte[6:0], in};
                data_bits_counter <= data_bits_counter + 1;
                if (data_bits_counter == 7) begin
                    state <= 3; // STOP_BIT
                end
            end
            3: begin // STOP_BIT
                if (in) begin
                    done <= 1;
                    out_byte <= byte;
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // IDLE
        endcase
        if (state != 3) begin
            done <= 0;
        end
    end
end

endmodule