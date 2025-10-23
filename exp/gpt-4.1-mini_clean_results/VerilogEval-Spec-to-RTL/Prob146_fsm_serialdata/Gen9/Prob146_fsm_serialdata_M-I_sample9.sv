module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg   done
);

    // State encoding with localparam for simpler synthesis
    localparam IDLE      = 2'b00,
               RECEIVE   = 2'b01,
               STOP      = 2'b10,
               WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;
    wire shift_en = (state == RECEIVE);

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // start bit detected
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
                    next_state = IDLE; // stop bit correct
                else
                    next_state = WAIT_STOP; // wait for stop bit
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

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter update only during RECEIVE
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE && in == 1'b0)
            bit_count <= 3'd0; // reset counter at start bit detection
        else if (shift_en)
            bit_count <= bit_count + 1;
    end

    // Shift register update only during RECEIVE
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0; // clear at start bit detection
        else if (shift_en)
            data_shift <= {in, data_shift[7:1]}; // LSB first (shift right)
    end

    // Output and done signal
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default deassert

            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

endmodule