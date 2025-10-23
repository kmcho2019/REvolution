module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);
    reg [2:0] state, next_state;

    // On reset (when FSM starts), load initial state from input y
    // For this example, assume a synchronous load on first clock cycle (state= y)
    // Otherwise, you can add an explicit reset if desired.
    // Here we assume 'y' is an input reflecting the current state,
    // but for internal FSM, we latch it on first clock.

    reg initialized;
    always @(posedge clk) begin
        if (!initialized) begin
            state <= y;
            initialized <= 1'b1;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic: define the FSM transitions based on current state and x
    always @(*) begin
        case(state)
            3'b000: next_state = (x == 0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000; // fallback state
        endcase
    end

    // Output logic: z = 1 when next_state is 3'b011 or 3'b100, else 0
    assign z = (next_state == 3'b011) || (next_state == 3'b100);

    // Y0 is LSB of next_state
    assign Y0 = next_state[0];

endmodule