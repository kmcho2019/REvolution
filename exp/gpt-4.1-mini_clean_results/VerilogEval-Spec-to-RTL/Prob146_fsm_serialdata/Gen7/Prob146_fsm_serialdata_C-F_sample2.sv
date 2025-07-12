module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count; // counts 0 to 7 bits received
    reg [7:0] data_shift;

    // Sequential logic: state updates every clock; other regs only updated as needed
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low each cycle unless set below
            done <= 1'b0;

            // Clear bit_count and data_shift only when start bit detected in IDLE
            if (state == IDLE && in == 1'b0) begin
                bit_count <= 3'd0;
                data_shift <= 8'd0;
            end

            // Shift in data and increment bit_count only in RECEIVE
            if (state == RECEIVE) begin
                // Shift in LSB first, data_shift[0] receives new bit
                data_shift <= {in, data_shift[7:1]};
                bit_count <= bit_count + 1;
            end

            // Output data and assert done only on valid stop bit in STOP state
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end

            // In WAIT_STOP or other states, no updates to bit_count or data_shift
        end
    end

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)       // Start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7) // All 8 data bits received
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)       // Correct stop bit
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP; // Wait for line idle after bad stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)       // Line idle detected
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule