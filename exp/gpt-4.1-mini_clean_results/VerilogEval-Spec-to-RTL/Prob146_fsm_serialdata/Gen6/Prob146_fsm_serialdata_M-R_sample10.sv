module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count, next_bit_count;
    reg [7:0] data_shift, next_data_shift;

    // Next-state and output logic (combinational)
    always @(*) begin
        // Defaults: hold values
        next_state = state;
        next_bit_count = bit_count;
        next_data_shift = data_shift;

        case(state)
            IDLE: begin
                if (in == 1'b0) begin // start bit detected
                    next_state = RECEIVE;
                    next_bit_count = 3'd0;
                    next_data_shift = 8'd0;
                end
            end

            RECEIVE: begin
                // Shift in LSB first on next clock
                next_data_shift = {in, data_shift[7:1]};
                if (bit_count == 3'd7)
                    next_state = STOP;
                next_bit_count = bit_count + 1'b1;
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
                // else remain in WAIT_STOP
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential state and data registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
        end else begin
            state <= next_state;
            bit_count <= next_bit_count;
            data_shift <= next_data_shift;

            // Update out_byte only when STOP state and valid stop bit
            if (state == STOP && in == 1'b1)
                out_byte <= data_shift;
        end
    end

    // done asserted combinationally when STOP state and valid stop bit on current cycle
    assign done = (state == STOP) && (in == 1'b1);

endmodule