module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define one-hot encoding states
reg [4:0] y; // current state (one-hot encoded)
reg [4:0] next_y; // next state (one-hot encoded)

// Stage 1: State Decoder
always @(*) begin
    case (1'b1)
        y[0]: next_y = x ? 4'b0001 : 4'b0001; // State 000
        y[1]: next_y = x ? 4'b1000 : 4'b0001; // State 001
        y[2]: next_y = x ? 4'b0001 : 4'b0010; // State 010
        y[3]: next_y = x ? 4'b0010 : 4'b0001; // State 011
        y[4]: next_y = x ? 4'b1000 : 4'b0100; // State 100
        default: next_y = 4'b0001;
    endcase
end

// Stage 2: Output Generator
always @(*) begin
    case (1'b1)
        y[3]: z = 1'b1; // State 011
        y[4]: z = 1'b1; // State 100
        default: z = 1'b0;
    endcase
end

// Sequential logic with clock gating
reg enable_clk;
always @(*) begin
    case (1'b1)
        y[0]: enable_clk = x ? 1'b1 : 1'b0; // State 000
        y[1]: enable_clk = x ? 1'b1 : 1'b0; // State 001
        y[2]: enable_clk = x ? 1'b1 : 1'b0; // State 010
        y[3]: enable_clk = x ? 1'b1 : 1'b0; // State 011
        y[4]: enable_clk = x ? 1'b0 : 1'b1; // State 100
        default: enable_clk = 1'b0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 4'b0001; // synchronous active high reset
    end else if (enable_clk) begin
        y <= next_y;
    end
end

endmodule