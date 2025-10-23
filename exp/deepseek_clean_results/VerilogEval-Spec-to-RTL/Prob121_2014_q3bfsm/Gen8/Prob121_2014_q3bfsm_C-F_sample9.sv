module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;

    // State transitions with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else case (state)
            3'b000: state <= x ? 3'b001 : 3'b000;  // Only LSB changes
            3'b001: state <= x ? 3'b100 : 3'b001;  // Gray-like transition when x=1
            3'b010: state <= x ? 3'b001 : 3'b010;  // Only LSB changes
            3'b011: state <= x ? 3'b010 : 3'b001;  // Adjacent state transitions
            3'b100: state <= x ? 3'b100 : 3'b011;  // Only one bit changes when x=0
        endcase
    end

    // Output is 1 when state is 3'b011 or 3'b100
    assign z = (state == 3'b011) | (state == 3'b100);

endmodule