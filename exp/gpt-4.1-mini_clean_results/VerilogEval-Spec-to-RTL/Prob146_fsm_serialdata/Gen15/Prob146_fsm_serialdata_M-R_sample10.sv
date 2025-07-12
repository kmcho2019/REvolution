module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded states
    localparam IDLE      = 4'b0001;
    localparam RECEIVE   = 4'b0010;
    localparam STOP      = 4'b0100;
    localparam WAIT_STOP = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Next state logic (combinational) using assign
    wire idle = state[0];
    wire receive = state[1];
    wire stop = state[2];
    wire wait_stop = state[3];

    // Next state signals
    wire next_idle;
    wire next_receive;
    wire next_stop;
    wire next_wait_stop;

    // Define next state logic combinationally
    assign next_idle = (idle && in) ||                 // stay idle if line is idle (high)
                       (stop && in) ||                 // stop bit correct -> back to idle
                       (wait_stop && in);              // stop bit finally detected

    assign next_receive = idle && ~in;                // start bit detected
    assign next_stop = receive && (bit_count == 3'd7);
    assign next_wait_stop = (stop && ~in) || (wait_stop && ~in);

    // Combine to next_state one-hot
    always @(*) begin
        next_state = 4'b0000;
        if (next_idle) next_state[0] = 1'b1;
        else if (next_receive) next_state[1] = 1'b1;
        else if (next_stop) next_state[2] = 1'b1;
        else if (next_wait_stop) next_state[3] = 1'b1;
        else next_state = IDLE; // default safe
    end

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // bit_count and data_shift update
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'd0;
            data_shift <= 8'd0;
        end else begin
            if (next_receive) begin
                // Starting a new byte reception, reset counter and data
                bit_count <= 3'd0;
                data_shift <= 8'd0;
            end else if (receive) begin
                // Shift in LSB first: shift right, put 'in' at MSB (same as before)
                data_shift <= {in, data_shift[7:1]};
                bit_count <= bit_count + 1;
            end
            // Hold values otherwise
        end
    end

    // done combinational signal (one cycle pulse)
    wire done_comb = (stop && in);

    // done and out_byte registered output
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= done_comb;
            if (done_comb)
                out_byte <= data_shift;
        end
    end

endmodule