module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
enum logic [1:0] {IDLE, DATA, STOP} state;

// Internal register to store the received byte
logic [7:0] byte;

// Internal counter to track the bit position
logic [2:0] bit_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte <= 8'd0;
        bit_count <= 3'd0;
        done <= 1'b0;
        out_byte <= 8'd0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // Start bit detected
                    state <= DATA;
                    bit_count <= 3'd1;
                end else begin
                    state <= IDLE;
                end
            end
            DATA: begin
                byte[7 - bit_count + 1] <= in; // Store the current bit of the byte
                bit_count <= bit_count + 1'd1;
                if (bit_count == 3'd8) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // Stop bit detected
                    done <= 1'b1;
                    out_byte <= byte;
                    state <= IDLE;
                end else begin // Incorrect stop bit, wait for stop bit
                    state <= STOP;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always_comb begin
    if (state == STOP && in) begin
        done = 1'b1;
    end else begin
        done = 1'b0;
    end
end

endmodule