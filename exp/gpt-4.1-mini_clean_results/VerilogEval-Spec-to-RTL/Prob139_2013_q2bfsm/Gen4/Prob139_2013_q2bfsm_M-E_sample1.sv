module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // One-hot state encoding (8 states)
    localparam 
        ST_RESET  = 8'b0000_0001,
        ST_PULSEF = 8'b0000_0010,
        ST_SEQ1   = 8'b0000_0100,
        ST_SEQ10  = 8'b0000_1000,
        ST_SEQ101 = 8'b0001_0000,
        ST_MON_Y  = 8'b0010_0000,
        ST_HOLD_G1= 8'b0100_0000,
        ST_HOLD_G0= 8'b1000_0000;

    reg [7:0] state, next_state;
    reg [1:0] monitor_count;

    // State register and monitor counter
    always @(posedge clk) begin
        if (!resetn) begin
            state <= ST_RESET;
            monitor_count <= 2'd0;
        end else begin
            state <= next_state;
            if (next_state == ST_MON_Y)
                monitor_count <= monitor_count + 1'b1;
            else
                monitor_count <= 2'd0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold

        case(state)
            ST_RESET: begin
                // Hold in reset until resetn=1, then pulse f once
                if (resetn)
                    next_state = ST_PULSEF;
                else
                    next_state = ST_RESET;
            end

            ST_PULSEF: begin
                // After one cycle with f=1, start sequence detection waiting for x=1
                next_state = ST_SEQ1;
            end

            ST_SEQ1: begin
                // Wait for x==1 to start sequence
                if (x)
                    next_state = ST_SEQ10;
                else
                    next_state = ST_SEQ1;
            end

            ST_SEQ10: begin
                // Wait for x==0 next
                if (!x)
                    next_state = ST_SEQ101;
                else
                    next_state = ST_SEQ10; // stay until 0 detected
            end

            ST_SEQ101: begin
                // Wait for x==1 final sequence detection step
                if (x)
                    next_state = ST_MON_Y;
                else
                    // sequence fail, restart detection
                    next_state = ST_SEQ1;
            end

            ST_MON_Y: begin
                // g=1, monitor y input for 2 cycles max
                // If y=1 within 2 cycles => hold g=1 permanently
                // If after 2 cycles no y=1 => hold g=0 permanently
                if (y)
                    next_state = ST_HOLD_G1;
                else if (monitor_count == 2'd1)
                    next_state = ST_HOLD_G0;
                else
                    next_state = ST_MON_Y;
            end

            ST_HOLD_G1: begin
                // hold g=1 until reset
                next_state = ST_HOLD_G1;
            end

            ST_HOLD_G0: begin
                // hold g=0 until reset
                next_state = ST_HOLD_G0;
            end

            default: begin
                next_state = ST_RESET;
            end
        endcase
    end

    // Output logic: Moore outputs depend only on current state
    always @(*) begin
        f = 1'b0;
        g = 1'b0;

        case(state)
            ST_PULSEF: f = 1'b1;

            ST_MON_Y,
            ST_HOLD_G1: g = 1'b1;

            ST_HOLD_G0: g = 1'b0;

            default: begin
                // f=0, g=0 by default
            end
        endcase
    end

endmodule