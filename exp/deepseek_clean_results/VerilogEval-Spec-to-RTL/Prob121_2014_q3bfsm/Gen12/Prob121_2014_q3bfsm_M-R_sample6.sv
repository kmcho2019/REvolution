module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000;
        endcase
    end

    // Sequential state register
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

    // Output logic
    assign z = (state == 3'b011) || (state == 3'b100);

endmodule