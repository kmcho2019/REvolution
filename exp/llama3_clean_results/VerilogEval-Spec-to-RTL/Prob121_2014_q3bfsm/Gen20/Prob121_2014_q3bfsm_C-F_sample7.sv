module SuperiorFSM(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [4:0] y; // one-hot encoded current state
reg [4:0] next_y; // one-hot encoded next state
reg [2:0] state_code; // current state code

// Stage 1: State Decoder
always @(*) begin
    case (state_code)
        3'b000: y = 5'b00001;
        3'b001: y = 5'b00010;
        3'b010: y = 5'b00100;
        3'b011: y = 5'b01000;
        3'b100: y = 5'b10000;
        default: y = 5'b00001;
    endcase
end

// Stage 2: Next State Computation
always @(*) begin
    case (1'b1)
        y[0]: next_y = x ? 5'b00010 : 5'b00001;
        y[1]: next_y = x ? 5'b10000 : 5'b00010;
        y[2]: next_y = x ? 5'b00010 : 5'b00100;
        y[3]: next_y = x ? 5'b00100 : 5'b00010;
        y[4]: next_y = x ? 5'b10000 : 5'b01000;
        default: next_y = 5'b00001;
    endcase
end

// Stage 3: Output Generator
always @(*) begin
    if (y[3] || y[4]) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

// Sequential logic with clock gating
always @(posedge clk) begin
    if (reset) begin
        state_code <= 3'b000; // synchronous active high reset
    end else begin
        case (1'b1)
            y[0]: state_code <= x ? 3'b001 : 3'b000;
            y[1]: state_code <= x ? 3'b100 : 3'b001;
            y[2]: state_code <= x ? 3'b001 : 3'b010;
            y[3]: state_code <= x ? 3'b010 : 3'b001;
            y[4]: state_code <= x ? 3'b100 : 3'b011;
            default: state_code <= 3'b000;
        endcase
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

SuperiorFSM superior_fsm(
    .clk(clk),
    .reset(reset),
    .x(x),
    .z(z)
);

endmodule