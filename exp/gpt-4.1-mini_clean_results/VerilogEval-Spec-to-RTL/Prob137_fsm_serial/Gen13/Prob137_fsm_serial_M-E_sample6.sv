module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (binary)
    localparam [1:0]
        IDLE       = 2'b00,
        RECEIVING  = 2'b01,
        STOP       = 2'b10,
        ERROR_WAIT = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (in == 1'b0) ? RECEIVING : IDLE; // start bit detected
            RECEIVING:
                next_state = (bit_count == 3'd7) ? STOP : RECEIVING;
            STOP: 
                next_state = (in == 1'b1) ? IDLE : ERROR_WAIT; // valid stop bit or error
            ERROR_WAIT:
                next_state = (in == 1'b1) ? IDLE : ERROR_WAIT; // wait for stop bit
            default: 
                next_state = IDLE;
        endcase
    end

    // FSM sequential logic and datapath
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done pulse

            case (state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end
                RECEIVING: begin
                    // Shift left by 1, insert new bit at LSB (LSB first protocol)
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    bit_count <= 3'd0;
                    // done pulse when valid stop bit
                    if (in == 1'b1)
                        done <= 1'b1;
                end
                ERROR_WAIT: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule