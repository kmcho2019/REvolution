module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output logic shift_ena,
    output logic counting,
    output logic done
);

    // One-hot state encoding
    typedef enum logic [6:0] {
        SEARCH0 = 7'b0000001, // no pattern bits matched
        SEARCH1 = 7'b0000010, // matched '1'
        SEARCH2 = 7'b0000100, // matched '11'
        SEARCH3 = 7'b0001000, // matched '110'
        SHIFT   = 7'b0010000, // shifting delay bits (4 cycles)
        COUNT   = 7'b0100000, // counting delay
        DONE    = 7'b1000000  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    // 3-bit shift counter (countdown from 4 to 0)
    // Represented as a 3-bit register holding remaining cycles
    logic [2:0] shift_count;

    // Synchronous sequential logic: state and shift_count
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT) begin
                if (shift_count != 3'd0)
                    shift_count <= shift_count - 3'd1;
            end else begin
                // reset counter outside SHIFT state
                shift_count <= 3'd4;
            end
        end
    end

    // Next state logic (combinational)
    always_comb begin
        next_state = state;
        case (state)
            SEARCH0: begin
                if (data)
                    next_state = SEARCH1;
                else
                    next_state = SEARCH0;
            end
            SEARCH1: begin
                if (data)
                    next_state = SEARCH2;
                else
                    next_state = SEARCH0;
            end
            SEARCH2: begin
                // Overlapping pattern support: if data==1 stay SEARCH2 else go SEARCH3
                if (~data)
                    next_state = SEARCH3;
                else
                    next_state = SEARCH2;
            end
            SEARCH3: begin
                if (data)
                    next_state = SHIFT;
                else
                    next_state = SEARCH0;
            end
            SHIFT: begin
                if (shift_count == 3'd0)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH0;
                else
                    next_state = DONE;
            end
            default: next_state = SEARCH0;
        endcase
    end

    // Outputs (Moore outputs) driven combinationally by state
    always_comb begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule