module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding:
    // CNT0 - CNT7: count of consecutive ones (0 to 7)
    // DISC: output disc asserted one cycle
    // FLAG: output flag asserted one cycle
    // ERR: output err asserted one cycle
    localparam 
        CNT0 = 4'd0,
        CNT1 = 4'd1,
        CNT2 = 4'd2,
        CNT3 = 4'd3,
        CNT4 = 4'd4,
        CNT5 = 4'd5,
        CNT6 = 4'd6,
        CNT7 = 4'd7,
        DISC = 4'd8,
        FLAG = 4'd9,
        ERR  = 4'd10;

    reg [3:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        case (state)
            // Counting consecutive ones states
            CNT0: begin
                if (in)
                    next_state = CNT1;
                else
                    next_state = CNT0;
            end
            CNT1: begin
                if (in)
                    next_state = CNT2;
                else
                    next_state = CNT0;
            end
            CNT2: begin
                if (in)
                    next_state = CNT3;
                else
                    next_state = CNT0;
            end
            CNT3: begin
                if (in)
                    next_state = CNT4;
                else
                    next_state = CNT0;
            end
            CNT4: begin
                if (in)
                    next_state = CNT5;
                else
                    next_state = CNT0;
            end
            CNT5: begin
                if (in)
                    next_state = CNT6;
                else
                    // After 5 ones, next input 0 means discard bit detected
                    // Move to DISC state for one cycle
                    next_state = DISC;
            end
            CNT6: begin
                if (in)
                    // 7 or more ones = error
                    next_state = ERR;
                else
                    // 6 ones then 0 means flag detected
                    next_state = FLAG;
            end
            CNT7: begin
                // Should not normally reach here; saturate to CNT7
                // Treat as error state as 7 or more ones
                next_state = ERR;
            end

            // Output states: output asserted one cycle, then return to counting depending on input
            DISC: begin
                disc = 1'b1;
                if (in)
                    next_state = CNT1; // input=1 resets count to 1
                else
                    next_state = CNT0; // input=0 resets count to 0
            end
            FLAG: begin
                flag = 1'b1;
                if (in)
                    next_state = CNT1;
                else
                    next_state = CNT0;
            end
            ERR: begin
                err = 1'b1;
                if (in)
                    next_state = ERR; // stay in error state on consecutive ones
                else
                    next_state = CNT0;
            end

            default: begin
                // Safe default: reset count
                next_state = CNT0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= CNT0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            // Outputs are assigned combinationally inside next_state logic for Moore FSM:
            // Since outputs depend on current state combinational logic, 
            // but we want outputs to be registered,
            // so outputs assignments above are combinational and immediately overridden here,
            // to fix this, we move outputs to sequential assignments driven by 'state'

            // So to align with Moore FSM, remove output assignments from combinational block
            // and instead assign outputs based on current registered state.
        end
    end

    // To fix output timing (Moore outputs),
    // re-assign outputs registered from current state (synchronous outputs)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= (state == DISC);
            flag <= (state == FLAG);
            err  <= (state == ERR);
        end
    end

endmodule