module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // State is a 2-bit byte counter: 0 = waiting for start byte, 1 or 2 = message bytes read
    reg [1:0] state, next_state;
    reg       done_next;

    // Combinational next state and done logic
    always @(*) begin
        done_next = 1'b0;
        next_state = state;

        case (state)
            2'b00: begin
                // Waiting for a byte with in[3] == 1 to start a message
                if (in[3])
                    next_state = 2'b01;
            end
            2'b01: begin
                // Received first byte, move to second byte
                next_state = 2'b10;
            end
            2'b10: begin
                // Received second byte, next is third byte
                next_state = 2'b11;
            end
            2'b11: begin
                // Received third byte, message complete
                done_next = 1'b1;
                next_state = 2'b00; // Reset to wait for next message start
            end
            default: next_state = 2'b00;
        endcase
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            done  <= done_next;
        end
    end

endmodule