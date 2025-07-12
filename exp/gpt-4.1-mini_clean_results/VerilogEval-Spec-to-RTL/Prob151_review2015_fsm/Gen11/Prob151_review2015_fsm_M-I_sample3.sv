module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    // One-hot state encoding with 7 states
    localparam SEARCH0 = 7'b0000001;
    localparam SEARCH1 = 7'b0000010;
    localparam SEARCH2 = 7'b0000100;
    localparam SEARCH3 = 7'b0001000;
    localparam SHIFT   = 7'b0010000;
    localparam COUNT   = 7'b0100000;
    localparam DONE    = 7'b1000000;

    reg [6:0] state, next_state;

    reg [1:0] shift_count;

    // Sequential logic for state and shift_count with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;

            if (state == SHIFT)
                shift_count <= shift_count + 2'b01;
            else
                shift_count <= 2'b00;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (1'b1) // Priority encoding based on one-hot state
            state[0]: next_state = data ? SEARCH1 : SEARCH0;       // SEARCH0
            state[1]: next_state = data ? SEARCH2 : SEARCH0;       // SEARCH1
            state[2]: next_state = (~data) ? SEARCH3 : SEARCH2;    // SEARCH2
            state[3]: next_state = data ? SHIFT : SEARCH0;         // SEARCH3
            state[4]: next_state = (shift_count == 2'b11) ? COUNT : SHIFT; // SHIFT
            state[5]: next_state = done_counting ? DONE : COUNT;   // COUNT
            state[6]: next_state = ack ? SEARCH0 : DONE;           // DONE
            default: next_state = SEARCH0;                          // Default safe
        endcase
    end

    // Outputs derived directly from one-hot state bits
    assign shift_ena = state[4];   // SHIFT
    assign counting  = state[5];   // COUNT
    assign done      = state[6];   // DONE

endmodule