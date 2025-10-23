module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot encoded states
    reg idle, receive, stop, error_wait;

    // Next state signals (combinational)
    wire idle_next, receive_next, stop_next, error_wait_next;

    // Bit counter and shift register
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // State registers update (one-hot)
    always @(posedge clk) begin
        if (reset) begin
            idle       <= 1'b1;
            receive    <= 1'b0;
            stop       <= 1'b0;
            error_wait <= 1'b0;
        end else begin
            idle       <= idle_next;
            receive    <= receive_next;
            stop       <= stop_next;
            error_wait <= error_wait_next;
        end
    end

    // Next state logic as continuous assignments
    assign idle_next = (idle & in) | (stop & in) | (error_wait & in) | (idle & (in==1'b1));
    assign receive_next = (idle & ~in) | (receive & (bit_cnt != 3'd7));
    assign stop_next = (receive & (bit_cnt == 3'd7));
    assign error_wait_next = (stop & ~in) | (error_wait & ~in);

    // Because states are one-hot, and mutually exclusive, fix combinations:
    // Prioritize error_wait if stop & ~in, else stop if receive done, else receive or idle as above.
    // To fix the above with priority and exclusivity, define signals with more careful logic:

    // Redefine next states with priority
    wire start_bit_detected = idle & ~in;
    wire last_data_bit = receive & (bit_cnt == 3'd7);
    wire stop_bit_correct = (in == 1'b1);
    wire stop_bit_incorrect = (in == 1'b0);

    assign idle_next =
        (error_wait & stop_bit_correct) |  // error_wait -> idle when stop bit received
        (stop & stop_bit_correct) |        // stop -> idle when stop bit received
        (idle & in & ~start_bit_detected); // remain idle if line idle (in==1)

    assign receive_next =
        (start_bit_detected) |             // idle -> receive on start bit
        (receive & (bit_cnt != 3'd7));    // remain in receive while bits < 7

    assign stop_next =
        (receive & (bit_cnt == 3'd7));    // receive -> stop after last data bit

    assign error_wait_next =
        (stop & stop_bit_incorrect) |     // stop -> error_wait on wrong stop bit
        (error_wait & stop_bit_incorrect);// remain error_wait if no stop bit yet

    // Bit counter increments only in receive
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (receive)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register shifts left, new bit into bit 0 (LSB-first)
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (receive)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // Output and done signal
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0;
            if (stop && stop_bit_correct) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

endmodule