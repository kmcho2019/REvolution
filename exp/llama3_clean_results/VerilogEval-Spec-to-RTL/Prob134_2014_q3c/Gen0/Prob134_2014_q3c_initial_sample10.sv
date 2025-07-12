module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

always @ (posedge clk) begin
    current_state <= next_state;
end

always @ (*) begin
    case (current_state)
        3'b000: begin
            if (!x) next_state = 3'b000;
            else next_state = 3'b001;
        end
        3'b001: begin
            if (!x) next_state = 3'b001;
            else next_state = 3'b100;
        end
        3'b010: begin
            if (!x) next_state = 3'b010;
            else next_state = 3'b001;
        end
        3'b011: begin
            if (!x) next_state = 3'b001;
            else next_state = 3'b010;
        end
        3'b100: begin
            if (!x) next_state = 3'b011;
            else next_state = 3'b100;
        end
        default: next_state = 3'b000;
    endcase
end

assign Y0 = next_state[0];

always @ (*) begin
    case (current_state)
        3'b000: z = 0;
        3'b001: z = 0;
        3'b010: z = 0;
        3'b011: z = 1;
        3'b100: z = 1;
        default: z = 0;
    endcase
end

endmodule