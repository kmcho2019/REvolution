module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding
    localparam SEARCH  = 1'b0;
    localparam CAPTURE = 1'b1;

    reg state, next_state;
    reg [1:0] byte_count, next_byte_count;
    reg [23:0] message_shift, next_message_shift;

    // Sequential logic: state, byte_count, message_shift, outputs
    always @(posedge clk) begin
        if (reset) begin
            state          <= SEARCH;
            byte_count     <= 2'd0;
            message_shift  <= 24'd0;
            out_bytes      <= 24'd0;
            done           <= 1'b0;
        end else begin
            state         <= next_state;
            byte_count    <= next_byte_count;
            message_shift <= next_message_shift;
            out_bytes     <= out_bytes;  // default hold value
            done          <= 1'b0;       // default done low

            if (state == CAPTURE && next_byte_count == 2'd3) begin
                // Message complete this cycle
                out_bytes <= next_message_shift;
                done      <= 1'b1;
            end
        end
    end

    // Combinational logic to determine next state and updates
    always @(*) begin
        next_state = state;
        next_byte_count = byte_count;
        next_message_shift = message_shift;

        case(state)
            SEARCH: begin
                done = 1'b0;
                if (in[3]) begin
                    // Sync byte found, start message
                    next_message_shift = {in, 16'd0};
                    next_byte_count = 2'd1;
                    next_state = CAPTURE;
                end
            end
            CAPTURE: begin
                // Shift new byte into message_shift
                // Left shift by 8 bits and insert new byte at LSB
                next_message_shift = {message_shift[15:0], in};
                next_byte_count = byte_count + 1;

                if (next_byte_count == 2'd3) begin
                    // Message complete, will signal done next clk cycle
                    next_state = SEARCH;
                    next_byte_count = 2'd0;
                end
            end
            default: begin
                next_state = SEARCH;
                next_byte_count = 2'd0;
                next_message_shift = 24'd0;
            end
        endcase
    end

endmodule