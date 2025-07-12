module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Hybrid encoding for state machine: A (2'b01), B (2'b10)
reg [1:0] state;

// Pipeline stage 1: State decoding and next state calculation
reg [1:0] next_state;
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case(state)
            2'b01: if(x) next_state <= 2'b10; else next_state <= 2'b01;
            2'b10: if(x) next_state <= 2'b10; else next_state <= 2'b10;
        endcase
    end
end

// Pipeline stage 2: Output generation
always @(posedge clk) begin
    state <= next_state;
    case(state)
        2'b01: z <= x;
        2'b10: z <= ~x;
    endcase
end

// Clock gating
reg clk_en;
always @(posedge clk) begin
    case(state)
        2'b01: if(x) clk_en <= 1'b1; else clk_en <= 1'b0;
        2'b10: if(~x) clk_en <= 1'b1; else clk_en <= 1'b0;
    endcase
end

// Gated clock
reg clk_gated;
always @(posedge clk or posedge areset) begin
    if(areset) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= clk_en;
    end
end

// Replace clk with clk_gated in sensitive lists
// However, due to the constraints of the problem, we cannot modify the clock.
// Instead, we can use the enable signal to selectively update the state.
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else if(clk_en) begin
        case(state)
            2'b01: if(x) state <= 2'b10; else state <= 2'b01;
            2'b10: if(x) state <= 2'b10; else state <= 2'b10;
        endcase
    end
end

assign z = (state == 2'b01) ? x : ~x;

endmodule