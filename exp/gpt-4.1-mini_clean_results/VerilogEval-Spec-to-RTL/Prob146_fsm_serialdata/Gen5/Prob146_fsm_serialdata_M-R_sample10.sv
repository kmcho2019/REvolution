module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count, next_bit_count;
    reg [7:0] data_shift, next_data_shift;
    reg next_done;
    reg [7:0] next_out_byte;

    // Combinational logic for next state and outputs
    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_bit_count = bit_count;
        next_data_shift = data_shift;
        next_done = 1'b0;
        next_out_byte = out_byte;

        case(state)
            IDLE: begin
                if (in == 1'b0) begin // detect start bit
                    next_state = RECEIVE;
                    next_bit_count = 3'd0;
                    next_data_shift = 8'd0;
                end
            end

            RECEIVE: begin
                // Shift in new bit LSB first
                next_data_shift = {in, data_shift[7:1]};
                if (bit_count == 3'd7) begin
                    next_state = STOP;
                end
                next_bit_count = bit_count + 1;
            end

            STOP: begin
                if (in == 1'b1) begin // valid stop bit
                    next_out_byte = data_shift;
                    next_done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP; // bad stop bit
                end
            end

            WAIT_STOP: begin
                if (in == 1'b1) begin // wait for line idle
                    next_state = IDLE;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Sequential logic for state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            bit_count <= next_bit_count;
            data_shift <= next_data_shift;
            out_byte <= next_out_byte;
            done <= next_done;
        end
    end

endmodule