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

    // One-hot encoded states (7 bits)
    localparam SEARCH0 = 7'b0000001; // no bits matched
    localparam SEARCH1 = 7'b0000010; // matched '1'
    localparam SEARCH2 = 7'b0000100; // matched '11'
    localparam SEARCH3 = 7'b0001000; // matched '110'
    localparam SHIFT   = 7'b0010000; // shifting 4 bits
    localparam COUNT   = 7'b0100000; // waiting for done_counting
    localparam DONE    = 7'b1000000; // done, waiting for ack

    reg [6:0] state, next_state;
    reg [1:0] shift_count;

    // Sequential logic: state and shift_count with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next-state combinational logic
    always @(*) begin
        // Default hold current state
        next_state = state;

        case (1'b1)
            state[0]: begin // SEARCH0: looking for first '1'
                if (data)
                    next_state = SEARCH1;
                else
                    next_state = SEARCH0;
            end
            state[1]: begin // SEARCH1: matched first '1'
                if (data)
                    next_state = SEARCH2;
                else
                    next_state = SEARCH0;
            end
            state[2]: begin // SEARCH2: matched '11'
                if (~data)
                    next_state = SEARCH3;
                else
                    next_state = SEARCH2; // stay here to handle overlapping patterns
            end
            state[3]: begin // SEARCH3: matched '110'
                if (data)
                    next_state = SHIFT;
                else
                    next_state = SEARCH0;
            end
            state[4]: begin // SHIFT: shift_ena asserted for 4 cycles
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            state[5]: begin // COUNT: wait for done_counting
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            state[6]: begin // DONE: assert done until ack
                if (ack)
                    next_state = SEARCH0;
                else
                    next_state = DONE;
            end
            default: next_state = SEARCH0;
        endcase
    end

    // Moore outputs combinational logic for glitch-free outputs
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule