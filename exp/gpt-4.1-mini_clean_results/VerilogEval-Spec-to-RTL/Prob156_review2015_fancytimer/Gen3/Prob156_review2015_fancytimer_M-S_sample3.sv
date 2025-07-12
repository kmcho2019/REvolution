module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // States
    localparam SEARCH    = 2'd0;
    localparam LOAD_DELAY= 2'd1;
    localparam COUNT     = 2'd2;
    localparam WAIT_ACK  = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [2:0] load_count;

    reg [11:0] cycle_count;   // Counts 0..999
    reg [3:0]  remaining;     // Counts down from delay to 0

    // State transitions
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: if (pattern_reg == 4'b1101)
                        next_state = LOAD_DELAY;
            LOAD_DELAY: if (load_count == 4)
                            next_state = COUNT;
            COUNT: if ((cycle_count == 12'd999) && (remaining == 4'd0))
                        next_state = WAIT_ACK;
            WAIT_ACK: if (ack)
                          next_state = SEARCH;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_reg <= 4'b0000;
            delay_reg <= 4'b0000;
            load_count <= 3'd0;
            cycle_count <= 12'd0;
            remaining <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift pattern in
                    pattern_reg <= {pattern_reg[2:0], data};
                    load_count <= 3'd0;
                    delay_reg <= 4'b0000;
                    cycle_count <= 12'd0;
                    remaining <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in MSB-first: shift left, insert new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_count <= load_count + 1;

                    // Freeze pattern_reg to ignore pattern detection during loading
                    pattern_reg <= pattern_reg;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_count <= 12'd0;
                    remaining <= 4'd0;
                end

                COUNT: begin
                    // Counting timer
                    counting <= 1'b1;
                    done <= 1'b0;
                    pattern_reg <= pattern_reg; // hold pattern_reg

                    // cycle_count increments until 999
                    if (cycle_count == 12'd999) begin
                        cycle_count <= 12'd0;
                        // Decrement remaining if not zero
                        if (remaining != 4'd0)
                            remaining <= remaining - 1;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end

                    // Output current remaining count
                    count <= remaining;
                end

                WAIT_ACK: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;
                    pattern_reg <= pattern_reg; // hold pattern_reg
                    load_count <= 3'd0;
                    delay_reg <= delay_reg;
                    cycle_count <= 12'd0;
                    remaining <= 4'd0;
                end

                default: begin
                    state <= SEARCH;
                    pattern_reg <= 4'b0000;
                    delay_reg <= 4'b0000;
                    load_count <= 3'd0;
                    cycle_count <= 12'd0;
                    remaining <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // On LOAD_DELAY to COUNT transition, initialize remaining count
            if (state == LOAD_DELAY && next_state == COUNT) begin
                remaining <= delay_reg; // delay_reg holds delay bits
                cycle_count <= 12'd0;
            end
        end
    end

endmodule