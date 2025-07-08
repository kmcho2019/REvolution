module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam A = 3'd0; // reset state
localparam B = 3'd1; // f=1 one cycle after reset
localparam C = 3'd2; // monitor x pattern 1,0,1
localparam D = 3'd3; // g=1 one cycle after pattern detected, start y monitor
localparam E = 3'd4; // g=1 permanent after y=1 within 2 cycles
localparam F = 3'd5; // g=0 permanent if y!=1 within 2 cycles

reg [2:0] state, next_state;

// For x pattern detection: states for detecting 1,0,1 pattern
// We'll implement a small sub-FSM here
localparam XPAT_START = 2'd0; // waiting for first 1
localparam XPAT_GOT1   = 2'd1; // got first 1, waiting for 0
localparam XPAT_GOT10  = 2'd2; // got 1,0, waiting for last 1

reg [1:0] xpat_state;
reg [1:0] xpat_next_state;

// y monitoring counter, counts from 0 to 2 cycles max
reg [1:0] y_count;

/////////////////////////////////////////////////////////////////////////
// Next state logic for main FSM
always @(*) begin
    next_state = state;
    case(state)
        A: begin
            if(resetn)
                next_state = B;
            else
                next_state = A;
        end
        B: begin
            // after output f=1 one cycle, go to C to monitor x pattern
            next_state = C;
        end
        C: begin
            // pattern detection FSM in xpat_state
            // if x pattern detected (xpat_state reaches XPAT_GOT10 and x=1),
            // transition to D
            if(xpat_state == XPAT_GOT10 && x == 1'b1)
                next_state = D;
            else
                next_state = C;
        end
        D: begin
            // g=1 one cycle here, start y monitor counter
            // if y=1 within 2 cycles => E
            // else after 2 cycles => F
            if(y == 1'b1)
                next_state = E;
            else if(y_count == 2)
                next_state = F;
            else
                next_state = D;
        end
        E: begin
            // permanent g=1
            next_state = E;
        end
        F: begin
            // permanent g=0
            next_state = F;
        end
        default: next_state = A;
    endcase
end

/////////////////////////////////////////////////////////////////////////
// x pattern detector FSM next state
always @(*) begin
    xpat_next_state = xpat_state;
    case(xpat_state)
        XPAT_START: begin
            if(x == 1'b1)
                xpat_next_state = XPAT_GOT1;
            else
                xpat_next_state = XPAT_START;
        end
        XPAT_GOT1: begin
            if(x == 1'b0)
                xpat_next_state = XPAT_GOT10;
            else if(x == 1'b1)
                xpat_next_state = XPAT_GOT1; // stay waiting for 0 after first 1
            else
                xpat_next_state = XPAT_START;
        end
        XPAT_GOT10: begin
            // waiting for last 1 to complete pattern
            if(x == 1'b1)
                xpat_next_state = XPAT_START; // pattern found, next main FSM handles transition
            else if(x == 1'b0)
                xpat_next_state = XPAT_START; // mismatch - restart
            else
                xpat_next_state = XPAT_START;
        end
        default: xpat_next_state = XPAT_START;
    endcase
end

/////////////////////////////////////////////////////////////////////////
// Sequential logic
always @(posedge clk) begin
    if(!resetn) begin
        // synchronous active low reset
        state <= A;
        xpat_state <= XPAT_START;
        y_count <= 2'd0;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        state <= next_state;

        // x pattern FSM only runs in state C; reset in others
        if(state == C) begin
            xpat_state <= xpat_next_state;
        end else begin
            xpat_state <= XPAT_START;
        end

        // y counter runs in state D
        if(state == D) begin
            if(y == 1'b1)
                y_count <= 2'd0; // found y=1, counter not needed further
            else
                y_count <= y_count + 1'b1;
        end else begin
            y_count <= 2'd0;
        end

        // Outputs f and g
        case(state)
            A: begin
                f <= 1'b0;
                g <= 1'b0;
            end
            B: begin
                f <= 1'b1; // output f=1 one cycle after resetn deasserted
                g <= 1'b0;
            end
            C: begin
                f <= 1'b0;
                g <= 1'b0;
            end
            D: begin
                f <= 1'b0;
                g <= 1'b1; // one cycle g=1 after pattern detected, also during y monitoring
            end
            E: begin
                f <= 1'b0;
                g <= 1'b1; // permanent g=1 after y=1 within 2 cycles
            end
            F: begin
                f <= 1'b0;
                g <= 1'b0; // permanent g=0 after y!=1 within 2 cycles
            end
            default: begin
                f <= 1'b0;
                g <= 1'b0;
            end
        endcase
    end
end

endmodule