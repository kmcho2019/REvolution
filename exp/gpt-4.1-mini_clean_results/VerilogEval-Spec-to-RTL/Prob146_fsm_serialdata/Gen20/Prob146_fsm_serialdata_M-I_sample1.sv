module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding using localparams for potentially smaller area
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;
    reg shift_enable;
    reg bitcount_enable;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = (in == 1'b0) ? RECEIVE : IDLE;

            RECEIVE: next_state = (bit_count == 3'd7) ? STOP : RECEIVE;

            STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

            WAIT_STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

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

    // Control enables for shift and bit counter
    always @(*) begin
        // Default disables
        shift_enable = 1'b0;
        bitcount_enable = 1'b0;

        if (state == RECEIVE) begin
            shift_enable = 1'b1;
            bitcount_enable = 1'b1;
        end else if (state == IDLE && in == 1'b0) begin
            // Prepare for new reception
            shift_enable = 1'b0;
            bitcount_enable = 1'b0;
        end
    end

    // Data shift and bit_count update
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'd0;
            data_shift <= 8'd0;
        end else begin
            if (state == IDLE && in == 1'b0) begin
                // Start bit detected, clear counters
                bit_count <= 3'd0;
                data_shift <= 8'd0;
            end else begin
                if (shift_enable) begin
                    // Shift right inserting new LSB at MSB side
                    data_shift <= {in, data_shift[7:1]};
                end
                if (bitcount_enable) begin
                    bit_count <= bit_count + 1;
                end
            end
        end
    end

    // Output logic and done signal generation (registered)
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each cycle

            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

endmodule