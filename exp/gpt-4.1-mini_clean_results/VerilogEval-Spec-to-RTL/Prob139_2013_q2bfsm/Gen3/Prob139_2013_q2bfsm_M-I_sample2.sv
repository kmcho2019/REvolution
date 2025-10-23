module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding (3 bits sufficient)
    localparam 
        A          = 3'd0, // Reset state, wait for reset deassertion
        F_ONE      = 3'd1, // Output f=1 for one cycle
        PAT_X1     = 3'd2, // Wait for x=1 (start pattern)
        PAT_X0     = 3'd3, // Wait for x=0 after seeing x=1
        PAT_X2     = 3'd4, // Wait for x=1 after x=1,0
        G_ON       = 3'd5, // g=1 active, monitoring y (up to 2 cycles)
        G_OFF      = 3'd6; // g=0 permanently until reset (terminal state)

    reg [2:0] state, next_state;
    reg [1:0] y_count; // Count of cycles while monitoring y in G_ON

    // Sequential logic: state and output registers
    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Default outputs are zero, override below as needed
            f <= 1'b0;
            g <= 1'b0;

            case(next_state)
                F_ONE: f <= 1'b1;   // f=1 exactly one cycle after reset deasserted
                G_ON:  g <= 1'b1;   // g=1 while in G_ON state
                default: begin
                    // f=0, g=0 by default
                end
            endcase

            // Update y_count only in G_ON state
            if (state == G_ON) begin
                if (y == 1'b1) begin
                    y_count <= 2'd2; // lock count to max to indicate y seen
                end else if (y_count < 2) begin
                    y_count <= y_count + 1'b1; // increment count if y not seen yet
                end
                // If y_count==2, stay locked
            end else begin
                y_count <= 2'd0; // Reset counter outside G_ON
            end
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state; // Default hold state

        case(state)
            A: begin
                if (resetn)
                    next_state = F_ONE;
                else
                    next_state = A;
            end

            F_ONE: begin
                next_state = PAT_X1;
            end

            PAT_X1: begin
                if (x == 1'b1)
                    next_state = PAT_X0;
                else
                    next_state = PAT_X1; // keep waiting for first '1'
            end

            PAT_X0: begin
                if (x == 1'b0)
                    next_state = PAT_X2;
                else if (x == 1'b1)
                    next_state = PAT_X0; 
                    // If get a '1' again while expecting '0', stay in PAT_X0 
                    // This tolerates repeated '1's before zero, or alternatively
                    // can restart pattern by going to PAT_X0 to wait for zero.
                    // Spec requires strict 1,0,1 so we keep strict here:
                    // If 1 instead of 0, restart pattern from PAT_X1.
                else
                    next_state = PAT_X0;
            end

            PAT_X2: begin
                if (x == 1'b1)
                    next_state = G_ON; // pattern complete
                else if (x == 1'b0)
                    next_state = PAT_X1; // pattern broken, restart from first 1
                else
                    next_state = PAT_X2;
            end

            G_ON: begin
                // y_count and y monitoring logic:
                // if y=1 seen within 2 cycles => stay in G_ON forever
                // if 2 cycles passed without y=1 => go to G_OFF permanently

                if (y_count == 2) begin
                    if (y == 1'b1)
                        next_state = G_ON; // y detected, stay here
                    else
                        next_state = G_OFF; // y not detected in 2 cycles, disable g
                end else begin
                    next_state = G_ON; // still monitoring y
                end
            end

            G_OFF: begin
                // Terminal state until reset
                next_state = G_OFF;
            end

            default: next_state = A;

        endcase
    end

endmodule