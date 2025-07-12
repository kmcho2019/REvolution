module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic
    wire [2:0] next_state;
    
    always @(*) begin
        if (x) begin
            case (y)
                3'b000: next_state = 3'b001;
                3'b001: next_state = 3'b100;
                3'b010: next_state = 3'b001;
                3'b011: next_state = 3'b010;
                3'b100: next_state = 3'b100;
                default: next_state = 3'b000;
            endcase
        end else begin
            case (y)
                3'b000: next_state = 3'b000;
                3'b001: next_state = 3'b001;
                3'b010: next_state = 3'b010;
                3'b011: next_state = 3'b001;
                3'b100: next_state = 3'b011;
                default: next_state = 3'b000;
            endcase
        end
    end

    // Output assignments
    assign Y0 = next_state[0];
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule