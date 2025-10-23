module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// Stage 1: State Decoder
always @(*) begin
    case (y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = 3'b000;
    endcase
end

// Stage 2: Output Generator
always @(*) begin
    case (y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Sequential logic with clock gating
reg clk_enable;
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
        clk_enable <= 1'b0;
    end else begin
        if (next_y != y) begin
            clk_enable <= 1'b1;
        end
        if (clk_enable) begin
            y <= next_y;
        end
    end
end

endmodule