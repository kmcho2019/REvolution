module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding
    reg [2:0] state, next_state;

    // State transitions
    always @(*) begin
        case (state)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000; // Handle undefined states
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

    // Output logic
    assign z = (state == 3'b011) || (state == 3'b100);

endmodule