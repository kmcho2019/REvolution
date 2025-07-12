module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] state, next_state;

    always @(*) begin
        case(state)
            3'b000: begin
                z = 1'b0;
                next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            end
            3'b001: begin
                z = 1'b0;
                next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            end
            3'b010: begin
                z = 1'b0;
                next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            end
            3'b011: begin
                z = 1'b1;
                next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            end
            3'b100: begin
                z = 1'b1;
                next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            end
            default: begin
                z = 1'b0;
                next_state = 3'b000;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

endmodule