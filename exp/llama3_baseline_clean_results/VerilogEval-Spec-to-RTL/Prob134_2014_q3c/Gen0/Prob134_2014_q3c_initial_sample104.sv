module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] present_state;
reg [2:0] next_state;

always @(*) begin
    case(present_state)
        3'b000: if (!x) next_state = 3'b000; else next_state = 3'b001;
        3'b001: if (!x) next_state = 3'b001; else next_state = 3'b100;
        3'b010: if (!x) next_state = 3'b010; else next_state = 3'b001;
        3'b011: if (!x) next_state = 3'b001; else next_state = 3'b010;
        3'b100: if (!x) next_state = 3'b011; else next_state = 3'b100;
        default: next_state = 3'b000;
    endcase

    Y0 = next_state[0];
    case(present_state)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

always @(posedge clk) begin
    present_state <= next_state;
end

initial begin
    present_state = 3'b000;
end

endmodule