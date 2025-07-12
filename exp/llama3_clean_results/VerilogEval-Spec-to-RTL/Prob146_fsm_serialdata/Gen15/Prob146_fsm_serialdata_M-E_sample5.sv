module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states for the finite state machine
localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;

reg [1:0] state;
reg [7:0] byte_reg;
reg [2:0] bit_counter;
reg start_bit_detected;
reg stop_bit_detected;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        byte_reg <= 8'b0;
        bit_counter <= 3'b000;
        start_bit_detected <= 0;
        stop_bit_detected <= 0;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (!in) begin
                    state <= START;
                    start_bit_detected <= 1;
                    bit_counter <= 3'b000;
                end
            end
            START: begin
                state <= DATA;
                bit_counter <= 3'b001;
            end
            DATA: begin
                byte_reg <= {byte_reg[6:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd8) begin
                    stop_bit_detected <= in;
                    if (in) begin
                        state <= IDLE;
                        done <= 1;
                        out_byte <= byte_reg;
                    end else begin
                        // Wait for stop bit
                        state <= DATA;
                    end
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
        if (state != DATA || bit_counter != 3'd8 || !stop_bit_detected) begin
            done <= 0;
        end
    end
end

endmodule