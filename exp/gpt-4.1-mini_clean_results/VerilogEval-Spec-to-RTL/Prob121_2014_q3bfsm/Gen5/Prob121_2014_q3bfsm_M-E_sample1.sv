module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end else begin
            // Determine next state and output based on current state and input x
            case (state)
                3'b000: begin
                    next_state = x ? 3'b001 : 3'b000;
                    z = 1'b0;
                end
                3'b001: begin
                    next_state = x ? 3'b100 : 3'b001;
                    z = 1'b0;
                end
                3'b010: begin
                    next_state = x ? 3'b001 : 3'b010;
                    z = 1'b0;
                end
                3'b011: begin
                    next_state = x ? 3'b010 : 3'b001;
                    z = 1'b1;
                end
                3'b100: begin
                    next_state = x ? 3'b100 : 3'b011;
                    z = 1'b1;
                end
                default: begin
                    next_state = 3'b000;
                    z = 1'b0;
                end
            endcase
            state <= next_state;
        end
    end

endmodule