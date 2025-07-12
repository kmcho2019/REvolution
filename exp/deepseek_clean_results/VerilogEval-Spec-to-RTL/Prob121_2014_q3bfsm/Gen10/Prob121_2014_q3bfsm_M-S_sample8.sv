module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;

    // State register with synchronous reset and next state logic
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else case (state)
            3'b000: state <= x ? 3'b001 : 3'b000;
            3'b001: state <= x ? 3'b100 : 3'b001;
            3'b010: state <= x ? 3'b001 : 3'b010;
            3'b011: state <= x ? 3'b010 : 3'b001;
            3'b100: state <= x ? 3'b100 : 3'b011;
            default: state <= 3'b000;
        endcase
    end

    // Output logic - z=1 when state is 011 or 100
    assign z = (state == 3'b011) | (state == 3'b100);

endmodule