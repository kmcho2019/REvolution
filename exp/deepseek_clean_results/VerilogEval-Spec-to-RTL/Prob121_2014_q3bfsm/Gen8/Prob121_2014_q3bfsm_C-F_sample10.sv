module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state, next_state;

    // Next state logic using case statement
    always @(*) begin
        case (state)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000; // Safe default
        endcase
    end

    // Output logic - optimized with bitwise OR
    assign z = (state == 3'b011) | (state == 3'b100);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

endmodule