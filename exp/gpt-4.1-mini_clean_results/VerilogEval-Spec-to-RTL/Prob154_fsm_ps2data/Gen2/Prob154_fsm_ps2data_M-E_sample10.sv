module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states
    localparam SEARCH  = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state, next_state;
    reg [1:0] byte_count; // counts bytes received (0 to 3)
    reg [23:0] shift_reg;

    // State and data registers update
    always @(posedge clk) begin
        if (reset) begin
            state      <= SEARCH;
            byte_count <= 2'd0;
            shift_reg  <= 24'd0;
            out_bytes  <= 24'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default no done

            case (state)
                SEARCH: begin
                    byte_count <= 2'd0;
                    if (in[3]) begin
                        // Start byte found: store it as MSByte
                        shift_reg <= {in, 16'd0};
                        byte_count <= 2'd1;
                    end
                end

                RECEIVE: begin
                    // Shift in next byte at LSB, move existing bytes up
                    shift_reg <= {shift_reg[15:0], in};
                    byte_count <= byte_count + 1;

                    // When 3 bytes collected, assert done next cycle
                    if (byte_count == 2'd2) begin
                        out_bytes <= {shift_reg[15:0], in};
                        done <= 1'b1;
                        byte_count <= 2'd0; // reset for next message
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            SEARCH:
                if (in[3])
                    next_state = RECEIVE;
                else
                    next_state = SEARCH;
            RECEIVE:
                // After done (3 bytes collected), go back to SEARCH
                if (done)
                    next_state = SEARCH;
                else
                    next_state = RECEIVE;
            default: next_state = SEARCH;
        endcase
    end

endmodule