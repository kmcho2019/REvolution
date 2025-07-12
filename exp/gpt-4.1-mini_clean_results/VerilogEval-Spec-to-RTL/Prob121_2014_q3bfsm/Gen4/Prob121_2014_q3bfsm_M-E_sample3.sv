module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // Binary encoding of states (3 bits)
    // State assignments per table:
    // 000: 3'b000
    // 001: 3'b001
    // 010: 3'b010
    // 011: 3'b011
    // 100: 3'b100

    reg [2:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000; // Should not occur
        endcase
    end

    // Output combinational logic based on current state
    always @(*) begin
        case (state)
            3'b000: z = 1'b0;
            3'b001: z = 1'b0;
            3'b010: z = 1'b0;
            3'b011: z = 1'b1;
            3'b100: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

endmodule