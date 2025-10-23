module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // Define states
    enum logic [2:0] {
        Idle,
        Start,
        Data,
        Stop,
        Error
    } state, next_state;

    // Counter for data bits
    logic [2:0] bit_counter;

    // Shift register for out_byte
    logic [7:0] out_byte_reg;

    always_comb begin
        // Default values
        done = 0;
        next_state = state;

        case (state)
            Idle: begin
                if (!in) begin
                    next_state = Start;
                end
            end
            Start: begin
                next_state = Data;
                bit_counter = 0;
            end
            Data: begin
                out_byte_reg = {out_byte_reg[6:0], in};
                if (bit_counter == 7) begin
                    next_state = Stop;
                end else begin
                    bit_counter = bit_counter + 1;
                end
            end
            Stop: begin
                if (in) begin
                    done = 1;
                    next_state = Idle;
                end else begin
                    next_state = Error;
                end
            end
            Error: begin
                if (in) begin
                    next_state = Idle;
                end
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= Idle;
            out_byte_reg <= 0;
            bit_counter <= 0;
        end else begin
            state <= next_state;
            out_byte <= (state == Stop && in) ? out_byte_reg : out_byte;
        end
    end

endmodule