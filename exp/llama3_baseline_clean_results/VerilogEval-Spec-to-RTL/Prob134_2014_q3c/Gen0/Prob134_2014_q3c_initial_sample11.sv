module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] next_state;

always @(y or x) begin
    case (y)
        3'b000: begin
            next_state = (x == 1'b0) ? 3'b000 : 3'b001;
        end
        3'b001: begin
            next_state = (x == 1'b0) ? 3'b001 : 3'b100;
        end
        3'b010: begin
            next_state = (x == 1'b0) ? 3'b010 : 3'b001;
        end
        3'b011: begin
            next_state = (x == 1'b0) ? 3'b001 : 3'b010;
        end
        3'b100: begin
            next_state = (x == 1'b0) ? 3'b011 : 3'b100;
        end
        default: next_state = 3'b000; // Default next state
    endcase
end

always @(y or x) begin
    case (y)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0; // Default output
    endcase
end

assign Y0 = (next_state[0]); // Extracting the LSB of next_state for Y0

endmodule