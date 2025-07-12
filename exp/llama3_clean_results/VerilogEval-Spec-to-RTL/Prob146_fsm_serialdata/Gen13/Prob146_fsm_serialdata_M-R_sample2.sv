module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [1:0] state;
reg [7:0] data;
reg [2:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        data <= 8'b0;
        bit_counter <= 3'b000;
        done <= 0;
    end
    else begin
        case(state)
            2'b00: // IDLE
                if (!in) begin
                    state <= 2'b01; // DATA
                    bit_counter <= 3'b001;
                end
            2'b01: // DATA
                begin
                    data <= {data[6:0], in}; // Shift data to the left and add new bit
                    if (bit_counter == 3'd7) begin
                        state <= 2'b10; // STOP
                    end
                    else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
            2'b10: // STOP
                if (in) begin // Correct stop bit
                    out_byte <= data;
                    done <= 1;
                    state <= 2'b00; // IDLE
                end
                else begin // Incorrect stop bit, wait for correct stop bit
                    done <= 0;
                end
            default:
                state <= 2'b00;
        endcase
    end
end

always @(posedge clk) begin
    if (state == 2'b10 && !in) begin // Incorrect stop bit
        done <= 0;
    end
    else if (state == 2'b00) begin // IDLE
        done <= 0;
    end
end

endmodule