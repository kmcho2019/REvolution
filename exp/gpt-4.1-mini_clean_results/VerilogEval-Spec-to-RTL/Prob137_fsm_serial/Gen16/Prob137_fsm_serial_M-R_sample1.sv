module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // One-hot state encoding: only one of these is 1 at a time
    reg idle, receive, check_stop, wait_stop;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Next state signals
    reg idle_nxt, receive_nxt, check_stop_nxt, wait_stop_nxt;

    // Next state combinational logic
    always @(*) begin
        // Default next states to 0
        idle_nxt = 1'b0;
        receive_nxt = 1'b0;
        check_stop_nxt = 1'b0;
        wait_stop_nxt = 1'b0;

        if (idle) begin
            if (in == 1'b0)
                receive_nxt = 1'b1;  // Start bit detected
            else
                idle_nxt = 1'b1;
        end else if (receive) begin
            if (bit_count == 3'd7)
                check_stop_nxt = 1'b1;
            else
                receive_nxt = 1'b1;
        end else if (check_stop) begin
            if (in == 1'b1)
                idle_nxt = 1'b1;     // Valid stop bit
            else
                wait_stop_nxt = 1'b1; // Framing error
        end else if (wait_stop) begin
            if (in == 1'b1)
                idle_nxt = 1'b1;     // Stop bit received
            else
                wait_stop_nxt = 1'b1;
        end else begin
            idle_nxt = 1'b1;         // Default reset state
        end
    end

    // Sequential state flip-flops and data registers
    always @(posedge clk) begin
        if (reset) begin
            idle       <= 1'b1;
            receive    <= 1'b0;
            check_stop <= 1'b0;
            wait_stop  <= 1'b0;
            shift_reg  <= 8'd0;
            bit_count  <= 3'd0;
        end else begin
            idle       <= idle_nxt;
            receive    <= receive_nxt;
            check_stop <= check_stop_nxt;
            wait_stop  <= wait_stop_nxt;

            if (idle_nxt) begin
                shift_reg <= 8'd0;
                bit_count <= 3'd0;
            end else if (receive) begin
                // Shift right, insert new bit at MSB for LSB first serial
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end else if (check_stop || wait_stop) begin
                bit_count <= 3'd0;
                if (wait_stop)
                    shift_reg <= 8'd0;
            end
        end
    end

    // Done pulse is combinational: high for one cycle when in CHECK_STOP with valid stop bit
    assign done = (check_stop && in);

endmodule