module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Define states
    parameter IDLE = 2'b00;
    parameter RECEIVING = 2'b01;
    parameter STOP = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg done_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            bit_count <= (state == RECEIVING) ? bit_count + 1 : 3'b0;
            done <= done_next;
        end
    end

    always @(*) begin
        next_state = state;
        done_next = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0) begin  // Start bit detected
                    next_state = RECEIVING;
                end
            end

            RECEIVING: begin
                if (bit_count == 3'b111) begin  // Received all 8 bits
                    next_state = STOP;
                end
            end

            STOP: begin
                if (in == 1'b1) begin  // Valid stop bit
                    done_next = 1'b1;
                    next_state = IDLE;
                end
                // Otherwise stay in STOP until we see stop bit
            end

            default: next_state = IDLE;
        endcase
    end

endmodule