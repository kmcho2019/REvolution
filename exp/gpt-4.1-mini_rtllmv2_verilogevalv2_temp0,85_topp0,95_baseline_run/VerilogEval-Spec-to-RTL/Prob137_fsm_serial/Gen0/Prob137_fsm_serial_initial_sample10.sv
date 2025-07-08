module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0,
               DATA      = 2'd1,
               STOP      = 2'd2,
               WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count; // count 0 to 7 data bits

    // Sequential state and bit_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
        end else begin
            state <= next_state;
            // bit_count only increments in DATA state
            if (state == DATA)
                bit_count <= bit_count + 3'd1;
            else
                bit_count <= 3'd0;
        end
    end

    // Next state logic
    always @(*) begin
        done = 1'b0;
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
            DATA: begin
                if (bit_count == 3'd7) // last data bit received
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule