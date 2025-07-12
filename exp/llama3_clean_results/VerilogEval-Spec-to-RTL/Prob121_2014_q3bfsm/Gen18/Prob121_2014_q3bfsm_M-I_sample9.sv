module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state
reg clk_en; // clock enable signal

// One-hot encoding for state machine implementation
reg [2:0] state;
reg [2:0] next_state;

// Stage 1: State Decoder
always @(*) begin
    case (state)
        3'b001: next_state = x? 3'b100 : 3'b001;
        3'b010: next_state = x? 3'b001 : 3'b010;
        3'b100: next_state = x? 3'b100 : 3'b011;
        default: next_state = x? 3'b001 : 3'b000;
    endcase
end

// Stage 2: Output Generator
always @(*) begin
    case (state)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Clock gating logic
always @(*) begin
    if (state == next_state) begin
        clk_en = 1'b0; // Disable clock if state doesn't change
    end else begin
        clk_en = 1'b1;
    end
end

// Sequential logic with clock gating
always @(posedge clk) begin
    if (clk_en || reset) begin
        if (reset) begin
            state <= 3'b001; // synchronous active high reset
        end else begin
            state <= next_state;
        end
    end
end

endmodule