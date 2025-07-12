module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // Binary encoded states (2 bits)
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP       = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_count;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with clock enable: increments only during RECEIVE state
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE && in == 1'b0) // Detect start bit, reset bit counter
            bit_count <= 3'd0;
        else if (state == RECEIVE)
            bit_count <= bit_count + 3'd1;
    end

    // Shift register, shift in LSB first on receive_enable (RECEIVE state)
    // Data shifted in at LSB side: data_shift = {new_bit, previous_data_shift[7:1]} means MSB first,
    // To keep LSB first, do shift left and insert at LSB:
    // data_shift = {in, data_shift[7:1]} shifts in at MSB,
    // To shift in LSB first we can do: data_shift = {in, data_shift[7:1]} if we count bits accordingly
    // But safer to shift left and put bit at LSB:
    // So shift left: data_shift = {in, data_shift[7:1]} - shifts in MSB; 
    // Instead shift right: data_shift = {1'b0, data_shift[7:1]} | in; or simpler: data_shift = {in, data_shift[7:1]}
    // Original code shifts MSB first but bit order is LSB first, so shift right inserting in MSB position is correct.
    // To clarify, keep same style as original but with clock enable and reset.
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0) // Start bit detected, reset data_shift
            data_shift <= 8'd0;
        else if (state == RECEIVE)
            data_shift <= {in, data_shift[7:1]}; // Shift right, LSB first from serial input
    end

    // done and out_byte updated only at STOP state on valid stop bit
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default no done
            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= data_shift;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
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

endmodule