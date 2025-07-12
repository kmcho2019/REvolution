module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // States encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        DATA  = 2'b01,
        STOP  = 2'b10
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count; // to count 8 bits (0 to 7)
    reg [7:0] data_shift; // received data byte (not strictly needed for done, but useful)

    // Sequential state transition and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done

            case(state)
                IDLE: begin
                    // wait for start bit 0 to begin data reception
                    if (in == 1'b0) begin
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end
                DATA: begin
                    data_shift <= {in, data_shift[7:1]}; // shift in LSB first: the first bit read is bit 0 (LSB)
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1; // valid stop bit received, mark done
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;
            end
            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;    // after valid stop bit, return to IDLE
                else
                    next_state = STOP;    // wait here until stop bit 1 is found
            end
        endcase
    end

endmodule