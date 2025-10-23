module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] state, next_state;

    // Combinational logic for next_state
    always @(*) begin
        case(state)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000;
        endcase
    end

    // Combinational logic for output z based on current state
    always @(*) begin
        case(state)
            3'b011, 3'b100: z = 1'b1;
            default:       z = 1'b0;
        endcase
    end

    // Sequential logic: state register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

endmodule