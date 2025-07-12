module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding (2-bit state plus separate found flag)
    localparam S0   = 2'b00;
    localparam S1   = 2'b01;
    localparam S11  = 2'b10;
    localparam S110 = 2'b11;

    reg [1:0] state, next_state;
    reg       found, next_found;

    // Next state and found logic
    always @(*) begin
        if (found) begin
            // Once found, stay found and state locked (could stay in current state)
            next_state = state;
            next_found = 1'b1;
        end else begin
            // FSM transitions for sequence detection
            case(state)
                S0: begin
                    next_found = 1'b0;
                    next_state = data ? S1 : S0;
                end
                S1: begin
                    next_found = 1'b0;
                    next_state = data ? S11 : S0;
                end
                S11: begin
                    next_found = 1'b0;
                    next_state = data ? S11 : S110;
                end
                S110: begin
                    if (data) begin
                        // Sequence 1101 detected
                        next_found = 1'b1;
                        next_state = S110; // lock here or could move to another state
                    end else begin
                        next_found = 1'b0;
                        next_state = S0;
                    end
                end
                default: begin
                    next_found = 1'b0;
                    next_state = S0;
                end
            endcase
        end
    end

    // Sequential logic: update state and found flag synchronously with reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            found <= 1'b0;
        end else begin
            state <= next_state;
            found <= next_found;
        end
    end

    // Moore output: start_shifting asserted when found flag is set
    assign start_shifting = found;

endmodule