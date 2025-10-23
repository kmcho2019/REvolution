module TopModule (
    input        clk,
    input        x,
    output       Y0,
    output       z
);

    reg [2:0] state;
    reg [2:0] next_state;

    // FSM next state logic (combinational)
    always @(*) begin
        case (state)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    // State register update (synchronous)
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output z depends on current state only
    assign z = (state == 3'b011 || state == 3'b100);

    // Output Y0 is LSB of next_state
    assign Y0 = next_state[0];

endmodule