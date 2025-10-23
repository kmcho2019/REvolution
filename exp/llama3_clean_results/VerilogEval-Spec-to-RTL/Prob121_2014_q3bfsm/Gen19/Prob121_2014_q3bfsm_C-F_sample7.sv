module OptimizedFSM(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state
reg [7:0] state_decode; // one-hot encoded current state
reg clk_en; // clock enable signal

// Stage 1: State Decoder
always @(*) begin
    case (y)
        3'b000: state_decode = 8'b00000001;
        3'b001: state_decode = 8'b00000010;
        3'b010: state_decode = 8'b00000100;
        3'b011: state_decode = 8'b00001000;
        3'b100: state_decode = 8'b00010000;
        default: state_decode = 8'b00000001;
    endcase
end

// Stage 2: Next State Computation
always @(*) begin
    case (1'b1)
        state_decode[0]: next_y = x ? 3'b001 : 3'b000;
        state_decode[1]: next_y = x ? 3'b100 : 3'b001;
        state_decode[2]: next_y = x ? 3'b001 : 3'b010;
        state_decode[3]: next_y = x ? 3'b010 : 3'b001;
        state_decode[4]: next_y = x ? 3'b100 : 3'b011;
        default: next_y = 3'b000;
    endcase
end

// Stage 3: Output Generator
always @(*) begin
    case (1'b1)
        state_decode[3], state_decode[4]: z = 1'b1;
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