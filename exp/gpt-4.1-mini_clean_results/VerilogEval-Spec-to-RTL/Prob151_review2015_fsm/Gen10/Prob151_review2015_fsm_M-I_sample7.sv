module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // One-hot state encoding (7 bits)
    localparam SEARCH0 = 7'b0000001; // no pattern bits matched
    localparam SEARCH1 = 7'b0000010; // matched '1'
    localparam SEARCH2 = 7'b0000100; // matched '11'
    localparam SEARCH3 = 7'b0001000; // matched '110'
    localparam SHIFT   = 7'b0010000; // shifting delay bits (4 cycles)
    localparam COUNT   = 7'b0100000; // counting delay
    localparam DONE    = 7'b1000000; // done, waiting for ack

    reg [6:0] state, next_state;

    // 4-bit shift register for shift_ena pulse: one-hot shift of a single '1' starting with LSB=1 for 4 cycles
    reg [3:0] shift_reg;

    // State and shift_reg update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_reg <= 4'b0000;
        end else begin
            state <= next_state;
            // Shift register runs only in SHIFT state
            if (state == SHIFT) begin
                // If shift_reg is zero, start pulse with LSB=1, else shift left
                if (shift_reg == 4'b0000)
                    shift_reg <= 4'b0001;
                else
                    shift_reg <= shift_reg << 1;
            end else begin
                shift_reg <= 4'b0000;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold
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
                if (~data)
                    next_state = SEARCH3;
                else
                    next_state = SEARCH2; // remain for overlapping
            end
            SEARCH3: begin
                if (data)
                    next_state = SHIFT;
                else
                    next_state = SEARCH0;
            end
            SHIFT: begin
                // Wait for 4 cycles (shift_reg has single '1' shifted left 4 times)
                if (shift_reg[3]) // pulse on 4th cycle
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

    // Outputs driven by state (Moore FSM)
    assign shift_ena = (state == SHIFT) && (shift_reg != 4'b0000);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule