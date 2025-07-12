module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // One-hot states
    localparam 
        ST_RESET     = 8'b0000_0001, // reset asserted
        ST_WAIT_REL  = 8'b0000_0010, // wait one cycle after resetn de-assertion
        ST_PULSEF    = 8'b0000_0100, // f=1 one cycle pulse
        ST_SEQ_DETECT= 8'b0000_1000, // detect sequence in a shift register
        ST_MONITOR_Y = 8'b0001_0000, // g=1 monitor y for up to 2 cycles
        ST_HOLD_G1   = 8'b0010_0000, // g=1 forever
        ST_HOLD_G0   = 8'b0100_0000; // g=0 forever

    reg [7:0] state, next_state;

    // Shift register holds last 3 samples of x for sequence detection
    reg [2:0] x_shift;

    // Counter for y monitoring in MONITOR_Y state (0 to 2)
    reg [1:0] monitor_count;

    // State register and counters
    always @(posedge clk) begin
        if (!resetn) begin
            state <= ST_RESET;
            x_shift <= 3'b000;
            monitor_count <= 2'd0;
        end else begin
            state <= next_state;

            // Update x_shift in SEQ_DETECT state only
            if (next_state == ST_SEQ_DETECT) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                // Clear x_shift in other states (not mandatory but clean)
                x_shift <= 3'b000;
            end

            // Update monitor_count only in MONITOR_Y state
            if (next_state == ST_MONITOR_Y) begin
                monitor_count <= monitor_count + 1'b1;
            end else begin
                monitor_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            ST_RESET: begin
                if (resetn)
                    next_state = ST_WAIT_REL;
                else
                    next_state = ST_RESET;
            end

            ST_WAIT_REL: begin
                // Wait exactly one cycle after resetn de-asserted before pulsing f
                next_state = ST_PULSEF;
            end

            ST_PULSEF: begin
                // After one cycle pulse f, start sequence detection
                next_state = ST_SEQ_DETECT;
            end

            ST_SEQ_DETECT: begin
                // Wait until last 3 x samples == 3'b101 (1,0,1)
                if (x_shift == 3'b101)
                    next_state = ST_MONITOR_Y;
                else
                    next_state = ST_SEQ_DETECT;
            end

            ST_MONITOR_Y: begin
                // Monitor y for up to 2 cycles
                if (y)
                    next_state = ST_HOLD_G1;
                else if (monitor_count == 2'd2)
                    next_state = ST_HOLD_G0;
                else
                    next_state = ST_MONITOR_Y;
            end

            ST_HOLD_G1: begin
                // Hold g=1 until reset
                if (!resetn)
                    next_state = ST_RESET;
                else
                    next_state = ST_HOLD_G1;
            end

            ST_HOLD_G0: begin
                // Hold g=0 until reset
                if (!resetn)
                    next_state = ST_RESET;
                else
                    next_state = ST_HOLD_G0;
            end

            default: begin
                next_state = ST_RESET;
            end
        endcase
    end

    // Output logic (Moore FSM, depends only on current state)
    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        case (state)
            ST_PULSEF: f = 1'b1;
            ST_MONITOR_Y,
            ST_HOLD_G1: g = 1'b1;
            ST_HOLD_G0: g = 1'b0;
            default: begin
                // f=0, g=0 default
            end
        endcase
    end

endmodule