module OptimizedFSM(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state
reg clk_en; // clock enable signal

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

// Stage 2: Next State Computation
// ( Combined with Stage 1 for simplicity )

// Stage 3: Output Generator
always @(*) begin
    case (y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Clock gating logic
always @(*) begin
    if (y == next_y) begin
        clk_en = 1'b0; // Disable clock if state doesn't change
    end else begin
        clk_en = 1'b1;
    end
end

// Sequential logic with clock gating
always @(posedge clk) begin
    if (clk_en || reset) begin
        if (reset) begin
            y <= 3'b000; // synchronous active high reset
        end else begin
            y <= next_y;
        end
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

OptimizedFSM optimized_fsm(
    .clk(clk),
    .reset(reset),
    .x(x),
    .z(z)
);

endmodule