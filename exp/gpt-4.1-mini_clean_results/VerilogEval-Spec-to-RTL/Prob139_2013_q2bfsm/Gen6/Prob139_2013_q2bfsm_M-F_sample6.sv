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
        ST_SEQ_DETECT= 8'b0000_1000, // detect sequence in a sliding window
        ST_MONITOR_Y = 8'b0001_0000, // g=1 monitor y for up to 2 cycles
        ST_HOLD_G1   = 8'b0010_0000, // g=1 forever
        ST_HOLD_G0   = 8'b0100_0000; // g=0 forever

    reg [7:0] state, next_state;

    // Shift register holds last 3 samples of x for sequence detection (sliding window)
    reg [2:0] x_shift;

    // Counter for y monitoring in MONITOR_Y state (0 to 2)
    reg [1:0] monitor_count;

    // State register and counters, shift register updated every cycle outside reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= ST_RESET;
            x_shift <= 3'b000;
            monitor_count <= 2'd0;
        end else begin
            state <= next_state;

            // Always shift in x after reset, keep sliding window of last 3 samples
            x_shift <= {x_shift[1:0], x};

            // monitor_count increments only in MONITOR_Y, reset otherwise
            if (state == ST_MONITOR_Y) begin
                monitor_count <= monitor_count + 1'b1;
            end else begin
                monitor_count <= 2'd0;
            end
        end
    end

    // Next state logic (combinational)
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
                // The x_shift is always updated, so detection is immediate
                if (x_shift == 3'b101)
                    next_state = ST_MONITOR_Y;
                else
                    next_state = ST_SEQ_DETECT;
            end

            ST_MONITOR_Y: begin
                // Monitor y for up to 2 cycles (monitor_count counts from 0 to 2)
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