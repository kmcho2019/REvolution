module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // One-hot state encoding
    localparam SEARCH0 = 10'b0000000001; // no bits matched
    localparam SEARCH1 = 10'b0000000010; // matched '1'
    localparam SEARCH2 = 10'b0000000100; // matched '11'
    localparam SEARCH3 = 10'b0000001000; // matched '110'
    localparam SHIFT0  = 10'b0000010000; // shift cycle 0
    localparam SHIFT1  = 10'b0000100000; // shift cycle 1
    localparam SHIFT2  = 10'b0001000000; // shift cycle 2
    localparam SHIFT3  = 10'b0010000000; // shift cycle 3
    localparam COUNT   = 10'b0100000000; // counting
    localparam DONE    = 10'b1000000000; // done, wait ack

    reg [9:0] state, next_state;

    // State and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic (combinational)
    always @(*) begin
        // Defaults
        next_state = SEARCH0;
        shift_ena   = 1'b0;
        counting    = 1'b0;
        done        = 1'b0;

        case (1'b1) // priority encoding for one-hot state
            state[0]: begin // SEARCH0
                if (data)
                    next_state = SEARCH1;
                else
                    next_state = SEARCH0;
            end
            state[1]: begin // SEARCH1
                if (data)
                    next_state = SEARCH2;
                else
                    next_state = SEARCH0;
            end
            state[2]: begin // SEARCH2
                if (~data)
                    next_state = SEARCH3;
                else
                    next_state = SEARCH2;
            end
            state[3]: begin // SEARCH3
                if (data)
                    next_state = SHIFT0;
                else
                    next_state = SEARCH0;
            end
            state[4]: begin // SHIFT0
                shift_ena = 1'b1;
                next_state = SHIFT1;
            end
            state[5]: begin // SHIFT1
                shift_ena = 1'b1;
                next_state = SHIFT2;
            end
            state[6]: begin // SHIFT2
                shift_ena = 1'b1;
                next_state = SHIFT3;
            end
            state[7]: begin // SHIFT3
                shift_ena = 1'b1;
                next_state = COUNT;
            end
            state[8]: begin // COUNT
                counting = 1'b1;
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            state[9]: begin // DONE
                done = 1'b1;
                if (ack)
                    next_state = SEARCH0;
                else
                    next_state = DONE;
            end
            default: begin
                next_state = SEARCH0;
            end
        endcase
    end

endmodule