module TopModule (
    input  wire        clk,
    input  wire        in,
    input  wire        reset,
    output reg  [7:0]  out_byte,
    output wire        done
);

    // FSM state encoding
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam STOP_CHECK = 2'd2;
    localparam RECOVER    = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_index;      // Counts bits received 0..7
    reg [7:0] shift_reg;      // Shift register for received data

    // Synchronous FSM and data shift logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_index <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Wait for start bit (logic 0) from idle line (logic 1)
                    // When start bit detected, clear bit_index and shift_reg
                    if (in == 1'b0) begin
                        bit_index <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in bit LSB first, shift_reg[0] is first bit received
                    // Shift right by 1 and put new bit at MSB, since LSB first
                    // Actually, since LSB first, input comes first into bit 0, so shift left and put at LSB
                    // But to keep LSB first, shift right and load at MSB or shift left and load at LSB? 
                    // It's simpler to shift right and load new bit at MSB to build LSB first
                    // However, because we want bit0 first, it's easier to shift left and put new bit at LSB

                    shift_reg <= {in, shift_reg[7:1]};
                    bit_index <= bit_index + 1'b1;
                end

                STOP_CHECK: begin
                    // Check stop bit correctness in next_state logic
                    // No changes to bit_index or shift_reg
                end

                RECOVER: begin
                    // Wait until line is idle again (logic 1)
                    // No changes to bit_index or shift_reg
                end

                default: begin
                    // default safe state
                    bit_index <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_index == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in == 1'b1) // Stop bit valid
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

    // done output: asserted combinationally when STOP_CHECK state and valid stop bit detected
    assign done = (state == STOP_CHECK) && (in == 1'b1);

    // latch out_byte on done
    always @(posedge clk) begin
        if (reset)
            out_byte <= 8'd0;
        else if (done)
            out_byte <= shift_reg;
    end

endmodule