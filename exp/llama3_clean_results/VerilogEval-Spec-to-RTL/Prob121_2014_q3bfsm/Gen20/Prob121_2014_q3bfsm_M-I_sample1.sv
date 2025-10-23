module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [4:0] y; // current state (one-hot encoding)
reg [4:0] next_y; // next state (one-hot encoding)

// Stage 1: State Decoder and Next State Computation
always @(*) begin
    case (y)
        5'b00001: next_y = x? 5'b00010 : 5'b00001;
        5'b00010: next_y = x? 5'b10000 : 5'b00010;
        5'b00100: next_y = x? 5'b00010 : 5'b00100;
        5'b01000: next_y = x? 5'b00100 : 5'b00010;
        5'b10000: next_y = x? 5'b10000 : 5'b01000;
        default: next_y = 5'b00001;
    endcase
end

// Stage 2: Output Generator
always @(*) begin
    case (y)
        5'b01000: z = 1'b1;
        5'b10000: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Clock gating logic
reg clk_en;
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
            y <= 5'b00001; // synchronous active high reset
        end else begin
            y <= next_y;
        end
    end
end

endmodule