module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding using localparams for broad compatibility
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    reg done_next;

    // Next state logic and output logic (combinational)
    always @(*) begin
        next_state = state;
        done_next  = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0) // Start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end
            CHECK_STOP: begin
                if (in == 1'b1) begin
                    done_next = 1'b1; // Valid stop bit, signal done
                    next_state = IDLE;
                end else
                    next_state = WAIT_STOP;
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

    // Sequential logic: state update, shift register and counter, done register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= done_next;

            case (state)
                IDLE: begin
                    shift_reg <= 8'b0;
                    bit_count <= 3'b0;
                end
                RECEIVE: begin
                    // Shift left by one, shift in input bit at LSB (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                CHECK_STOP: begin
                    bit_count <= 3'b0; // Reset counter for next byte
                end
                WAIT_STOP: begin
                    shift_reg <= 8'b0;
                    bit_count <= 3'b0;
                end
            endcase
        end
    end

endmodule