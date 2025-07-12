// State module for OFF state
module OffState(
    input  clk,
    input  reset,
    input  j,
    output reg out,
    output reg nextState
);

always @(posedge clk) begin
    if (reset) begin
        out <= 0;
        nextState <= 0;
    end else begin
        out <= 0;
        if (j) begin
            nextState <= 1;
        end else begin
            nextState <= 0;
        end
    end
end

endmodule

// State module for ON state
module OnState(
    input  clk,
    input  reset,
    input  k,
    output reg out,
    output reg nextState
);

always @(posedge clk) begin
    if (reset) begin
        out <= 0;
        nextState <= 0;
    end else begin
        out <= 1;
        if (k) begin
            nextState <= 0;
        end else begin
            nextState <= 1;
        end
    end
end

endmodule

// Top-level module orchestrating state transitions
module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Current state (0 - OFF, 1 - ON)
reg next_state; // Next state

OffState off_state_inst(
    .clk(clk),
    .reset(reset),
    .j(j),
    .out(out),
    .nextState(next_state)
);

OnState on_state_inst(
    .clk(clk),
    .reset(reset),
    .k(k),
    .out(out),
    .nextState(next_state)
);

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1;
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: out = off_state_inst.out;
        1: out = on_state_inst.out;
    endcase
end

endmodule