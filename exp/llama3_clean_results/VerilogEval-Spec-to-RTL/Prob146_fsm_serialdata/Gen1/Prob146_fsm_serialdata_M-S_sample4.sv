module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
logic [1:0] state, next_state;

// Register to store the received byte
logic [7:0] byte;

// Counter for the data bits
logic [2:0] bit_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        out_byte <= 8'b0;
        done <= 1'b0;
        byte <= 8'b0;
        bit_count <= 3'b0;
    end else begin
        state <= next_state;
        case (state)
            2'b00: begin // IDLE
                if (in == 1'b0) begin
                    next_state <= 2'b01; // START
                end else begin
                    next_state <= 2'b00; // IDLE
                end
            end
            2'b01: begin // START
                next_state <= 2'b10; // DATA
                byte[0] <= in;
                bit_count <= 1;
            end
            2'b10: begin // DATA
                if (bit_count == 8'd8) begin
                    next_state <= 2'b11; // STOP
                end else begin
                    next_state <= 2'b10; // DATA
                    byte[bit_count] <= in;
                    bit_count <= bit_count + 1;
                end
            end
            2'b11: begin // STOP
                if (in == 1'b1) begin
                    next_state <= 2'b00; // IDLE
                    out_byte <= byte;
                    done <= 1'b1;
                end else begin
                    next_state <= 2'b00; // IDLE
                    done <= 1'b0;
                end
            end
            default: next_state <= 2'b00; // IDLE
        endcase
        if (state != 2'b11) begin
            done <= 1'b0;
        end
    end
end

endmodule