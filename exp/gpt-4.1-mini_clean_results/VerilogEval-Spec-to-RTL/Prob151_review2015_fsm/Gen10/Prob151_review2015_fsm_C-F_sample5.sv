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

    // State encoding using localparam for compatibility and clarity
    localparam [2:0]
        SEARCH0 = 3'd0, // no bits matched yet
        SEARCH1 = 3'd1, // matched '1'
        SEARCH2 = 3'd2, // matched '11'
        SEARCH3 = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shifting in 4 bits
        COUNT   = 3'd5, // counting in progress
        DONE    = 3'd6; // done, waiting for ack

    reg [2:0] state, next_state;
    reg [1:0] shift_count; // 2-bit counter for 4 cycles in SHIFT

    // Sequential logic: state and shift_count registers with synchronous reset
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

    // Combinational next-state logic implementing pattern detection and FSM flow
    always @(*) begin
        case (state)
            SEARCH0: 
                next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: 
                next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: 
                next_state = (~data) ? SEARCH3 : SEARCH2;
            SEARCH3: 
                next_state = (data) ? SHIFT : SEARCH0;
            SHIFT:   
                next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:   
                next_state = (done_counting) ? DONE : COUNT;
            DONE:    
                next_state = (ack) ? SEARCH0 : DONE;
            default: 
                next_state = SEARCH0;
        endcase
    end

    // Outputs (Moore type): combinational from current state for timing clarity
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule