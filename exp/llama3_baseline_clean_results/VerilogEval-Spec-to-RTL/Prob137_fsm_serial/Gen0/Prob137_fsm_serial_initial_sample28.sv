module TopModule (
    input           clk,
    input           reset,
    input           in,
    output          done
);

    // Define states
    enum logic [2:0] {IDLE, RECEIVE, VERIFY} state, next_state;
    reg [7:0] data; // Store the received data
    reg [2:0] bit_count; // Count the received bits

    // Combinational logic for next state
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (~in) next_state = RECEIVE;
            end
            RECEIVE: begin
                if (bit_count == 8) next_state = VERIFY;
            end
            VERIFY: begin
                if (in) next_state = IDLE;
                else next_state = VERIFY; // Wait for stop bit
            end
        endcase
    end

    // Sequential logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data <= 0;
        end else begin
            state <= next_state;
            case (state)
                RECEIVE: begin
                    // Shift in the received bit to the data register
                    data <= {data[6:0], in};
                    bit_count <= bit_count + 1;
                end
                IDLE: begin
                    bit_count <= 0;
                    data <= 0;
                end
                VERIFY: begin
                    // Assert done signal for one clock cycle
                    if (in) begin
                        done <= 1'b1;
                    end else begin
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

    // Assign done output
    assign done = (state == VERIFY && in);

endmodule