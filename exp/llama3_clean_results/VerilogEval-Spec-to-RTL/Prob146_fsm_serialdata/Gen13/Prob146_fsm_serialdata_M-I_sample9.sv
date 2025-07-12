module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

parameter IDLE = 2'b00, DATA = 2'b01, STOP = 2'b10;

reg [1:0] state;
reg [7:0] data;
reg [2:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 3'b000;
        out_byte <= 8'b0;
        done <= 0;
    end
    else begin
        case(state)
            IDLE: begin
                if (!in) begin // Start bit detected
                    state <= DATA;
                    bit_counter <= 3'b001;
                end
            end
            DATA: begin
                data <= {in, data[7:1]}; // Shift in the new bit
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd8) begin // All data bits received
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // Correct stop bit
                    out_byte <= data;
                    done <= 1;
                    state <= IDLE;
                end
                else begin // Incorrect stop bit, stay in STOP
                    done <= 0;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule