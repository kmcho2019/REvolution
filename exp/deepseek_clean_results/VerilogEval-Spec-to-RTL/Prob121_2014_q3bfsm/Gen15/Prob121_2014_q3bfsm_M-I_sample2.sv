module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;
    wire [2:0] next_state;

    // Next state logic
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

    // State register with clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end
        else if (state != next_state) begin
            state <= next_state;
            z <= (next_state == 3'b011) || (next_state == 3'b100);
        end
    end

endmodule