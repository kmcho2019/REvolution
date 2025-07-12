module TopModule (
    input        clk,
    input        resetn,
    input        x,
    input        y,
    output       f,
    output       g
);

    // Define states
    enum logic [2:0] {StateA, StateB, StateC, StateD, StateE, StateF} state, next_state;

    // Counter for StateC and StateD
    logic [1:0] counter;

    // Sequence detector for StateC
    logic [1:0] seq_counter;

    // Flag to track if sequence 1, 0, 1 is detected
    logic seq_detected;

    always_ff @(posedge clk) begin
        if (~resetn) begin
            state <= StateA;
            counter <= 0;
            seq_counter <= 0;
            seq_detected <= 0;
            f <= 0;
            g <= 0;
        end else begin
            state <= next_state;
            counter <= counter + 1;
            f <= 0;
            g <= 0;

            case (state)
                StateA: begin
                    if (~resetn) begin
                        next_state <= StateA;
                    end else begin
                        next_state <= StateB;
                    end
                end

                StateB: begin
                    f <= 1;
                    next_state <= StateC;
                end

                StateC: begin
                    case (seq_counter)
                        0: begin
                            if (x) begin
                                seq_counter <= seq_counter + 1;
                            end
                        end
                        1: begin
                            if (~x) begin
                                seq_counter <= seq_counter + 1;
                            end else begin
                                seq_counter <= 0;
                            end
                        end
                        2: begin
                            if (x) begin
                                seq_detected <= 1;
                                next_state <= StateD;
                            end else begin
                                seq_counter <= 0;
                            end
                        end
                    endcase
                end

                StateD: begin
                    g <= 1;
                    if (y || counter >= 2) begin
                        if (y) begin
                            next_state <= StateE;
                        end else begin
                            next_state <= StateF;
                        end
                        counter <= 0;
                    end
                end

                StateE: begin
                    g <= 1;
                    next_state <= StateE;
                end

                StateF: begin
                    next_state <= StateF;
                end
            endcase
        end
    end

endmodule