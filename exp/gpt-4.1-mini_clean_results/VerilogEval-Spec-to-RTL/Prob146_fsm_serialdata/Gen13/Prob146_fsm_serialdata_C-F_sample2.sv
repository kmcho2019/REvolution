module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (typedef enum reg) for clarity and 2-bit binary encoding
    typedef enum reg [1:0] {
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        STOP       = 2'b10,
        WAIT_STOP  = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_count;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: 
                if (in == 1'b0) // Start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;

            RECEIVE: 
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;

            STOP: 
                if (in == 1'b1)   // Valid stop bit
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;

            WAIT_STOP:
                if (in == 1'b1)   // Wait until line idle (stop bit=1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;

            default: next_state = IDLE;
        endcase
    end

    // State register update (synchronous reset)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Data shifting and bit counting in one sequential block
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'd0;
            data_shift <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    // When start bit detected (line goes low), clear counter and shift register
                    if (in == 1'b0) begin
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in new bit (MSB first in shift reg) LSB first serial protocol
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 3'd1;
                end

                default: begin
                    // Hold registers in STOP and WAIT_STOP states
                    bit_count <= bit_count;
                    data_shift <= data_shift;
                end
            endcase
        end
    end

    // Output and done signal logic: done asserted one cycle at valid stop bit
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // Default no done pulse

            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

endmodule