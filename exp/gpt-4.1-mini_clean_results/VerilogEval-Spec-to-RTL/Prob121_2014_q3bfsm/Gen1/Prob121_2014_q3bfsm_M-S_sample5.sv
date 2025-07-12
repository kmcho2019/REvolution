module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] state;

    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else begin
            case(state)
                3'b000: state <= (x == 1'b0) ? 3'b000 : 3'b001;
                3'b001: state <= (x == 1'b0) ? 3'b001 : 3'b100;
                3'b010: state <= (x == 1'b0) ? 3'b010 : 3'b001;
                3'b011: state <= (x == 1'b0) ? 3'b001 : 3'b010;
                3'b100: state <= (x == 1'b0) ? 3'b011 : 3'b100;
                default: state <= 3'b000;
            endcase
        end
    end

    always @(*) begin
        case(state)
            3'b011, 3'b100: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule