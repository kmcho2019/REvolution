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

    // State encoding using localparam for clarity and compatibility
    localparam [2:0]
        SEARCH0 = 3'd0, // no bits matched yet
        SEARCH1 = 3'd1, // matched '1'
        SEARCH2 = 3'd2, // matched '11'
        SEARCH3 = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shifting in 4 bits
        COUNT   = 3'd5, // counting in progress
        DONE    = 3'd6; // done, waiting for ack

    reg [2:0] state, next_state;
    reg [1:0] shift_count; // 2-bit counter for exactly 4 SHIFT cycles

    // Sequential logic: state and shift_count update on clk with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Shift counter increments only in SHIFT state, else reset to zero
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end

            // Output registers updated synchronously (Moore outputs from state)
            shift_ena <= (next_state == SHIFT);
            counting  <= (next_state == COUNT);
            done      <= (next_state == DONE);
        end
    end

    // Combinational logic for next state calculation
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

endmodule