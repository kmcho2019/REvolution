module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding with direction included
    parameter WL = 3'b000; // Walk left
    parameter WR = 3'b001; // Walk right
    parameter FL = 3'b010; // Fall left
    parameter FR = 3'b011; // Fall right
    parameter DL = 3'b100; // Dig left
    parameter DR = 3'b101; // Dig right
    parameter SPLAT = 3'b111; // Splattered

    reg [2:0] state;
    reg [4:0] fall_cycles;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_cycles <= 0;
        end else begin
            case (state)
                WL, WR: begin
                    if (!ground) begin
                        // Fall has highest priority
                        state <= state[0] ? FR : FL;
                        fall_cycles <= 1;
                    end else if (dig) begin
                        // Dig has priority over bump
                        state <= state[0] ? DR : DL;
                    end else if ((state == WL && bump_left) || (state == WR && bump_right)) begin
                        // Only change direction if not falling/digging
                        state <= state[0] ? WL : WR;
                    end
                end

                FL, FR: begin
                    if (ground) begin
                        // Check splatter condition when landing
                        if (fall_cycles > 20)
                            state <= SPLAT;
                        else
                            state <= state[0] ? WR : WL;
                        fall_cycles <= 0;
                    end else begin
                        // Continue falling
                        fall_cycles <= fall_cycles + 1;
                    end
                end

                DL, DR: begin
                    if (!ground) begin
                        // Transition to falling when ground disappears
                        state <= state[0] ? FR : FL;
                        fall_cycles <= 1;
                    end
                    // Remain digging otherwise (dig input ignored during digging)
                end

                SPLAT: begin
                    // Stay in splatter state forever
                    state <= SPLAT;
                end
            endcase
        end
    end

    // Output assignments based on current state
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule