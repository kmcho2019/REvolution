module TopModule (
    input        clk,
    input        reset,   // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // State encoding (Verilog-2001 style parameters)
    parameter SEARCH   = 2'd0;
    parameter LOAD     = 2'd1;
    parameter COUNT    = 2'd2;
    parameter WAIT_ACK = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay_reg;
    reg [2:0] load_bit_cnt; // counts 0..3 for 4 bits loaded

    // Cycle counter (16 bits)
    reg [15:0] cycle_counter;

    // Count limit register (16 bits)
    reg [15:0] count_limit_reg;

    // Calculate total cycles = (delay+1)*1000
    // Assign during LOAD->COUNT transition only
    // Using 16-bit math is safe (max 16*1000=16000 < 65535)

    // Pattern detected signal
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Next state logic
    always @(*) begin
        case(state)
            SEARCH:  next_state = pattern_detected ? LOAD : SEARCH;
            LOAD:    next_state = (load_bit_cnt == 3'd4) ? COUNT : LOAD;
            COUNT:   next_state = (cycle_counter == count_limit_reg) ? WAIT_ACK : COUNT;
            WAIT_ACK: next_state = ack ? SEARCH : WAIT_ACK;
            default: next_state = SEARCH;
        endcase
    end

    // Sequential logic for FSM and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'd0;
            load_bit_cnt <= 3'd0;
            cycle_counter <= 16'd0;
            count_limit_reg <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in pattern bits MSB-first (shift left, insert data LSB)
                    pattern_shift <= {pattern_shift[2:0], data};

                    // delay_reg and counters retain or reset
                    delay_reg <= delay_reg;
                    load_bit_cnt <= 3'd0;
                    cycle_counter <= 16'd0;
                    count_limit_reg <= 16'd0;
                end

                LOAD: begin
                    // Shift in delay bits MSB-first on each clk (4 bits)
                    delay_reg <= {delay_reg[2:0], data};
                    load_bit_cnt <= load_bit_cnt + 1;

                    // Freeze pattern_shift
                    pattern_shift <= pattern_shift;

                    // Clear counting counters during load
                    cycle_counter <= 16'd0;
                    count_limit_reg <= 16'd0;
                end

                COUNT: begin
                    // Freeze pattern_shift and delay_reg during counting
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    load_bit_cnt <= load_bit_cnt;

                    // Increment cycle counter until count_limit_reg reached
                    if (cycle_counter < count_limit_reg)
                        cycle_counter <= cycle_counter + 1;
                    else
                        cycle_counter <= cycle_counter;
                    count_limit_reg <= count_limit_reg;
                end

                WAIT_ACK: begin
                    // Freeze all except clearing counters & load count
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    load_bit_cnt <= 3'd0;
                    cycle_counter <= 16'd0;
                    count_limit_reg <= 16'd0;
                end

                default: begin
                    // Safety reset all registers
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'd0;
                    load_bit_cnt <= 3'd0;
                    cycle_counter <= 16'd0;
                    count_limit_reg <= 16'd0;
                end
            endcase

            // On transition LOAD->COUNT, latch count_limit_reg to (delay+1)*1000 -1
            if (state == LOAD && next_state == COUNT) begin
                count_limit_reg <= (delay_reg + 1) * 1000 - 1;
                cycle_counter <= 16'd0;
            end
        end
    end

    // Combinational calculation of quotient = cycle_counter / 1000 without loops or internal variables
    // Quotient max value is 16 (max delay +1)
    // Use simple if-else to find quotient

    reg [4:0] quotient; // max 16

    always @(*) begin
        if      (cycle_counter >= 16000) quotient = 5'd16;
        else if (cycle_counter >= 15000) quotient = 5'd15;
        else if (cycle_counter >= 14000) quotient = 5'd14;
        else if (cycle_counter >= 13000) quotient = 5'd13;
        else if (cycle_counter >= 12000) quotient = 5'd12;
        else if (cycle_counter >= 11000) quotient = 5'd11;
        else if (cycle_counter >= 10000) quotient = 5'd10;
        else if (cycle_counter >=  9000) quotient = 5'd9;
        else if (cycle_counter >=  8000) quotient = 5'd8;
        else if (cycle_counter >=  7000) quotient = 5'd7;
        else if (cycle_counter >=  6000) quotient = 5'd6;
        else if (cycle_counter >=  5000) quotient = 5'd5;
        else if (cycle_counter >=  4000) quotient = 5'd4;
        else if (cycle_counter >=  3000) quotient = 5'd3;
        else if (cycle_counter >=  2000) quotient = 5'd2;
        else if (cycle_counter >=  1000) quotient = 5'd1;
        else                              quotient = 5'd0;
    end

    // Output logic combinational
    always @(*) begin
        counting = 1'b0;
        done     = 1'b0;
        count    = 4'bxxxx;

        case(state)
            SEARCH: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end

            LOAD: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end

            COUNT: begin
                counting = 1'b1;
                done = 1'b0;
                // Calculate remaining ticks = delay_reg - quotient, saturate at 0
                if (delay_reg >= quotient[3:0])
                    count = delay_reg - quotient[3:0];
                else
                    count = 4'd0;
            end

            WAIT_ACK: begin
                counting = 1'b0;
                done = 1'b1;
                count = 4'bxxxx;
            end

            default: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end
        endcase
    end

endmodule