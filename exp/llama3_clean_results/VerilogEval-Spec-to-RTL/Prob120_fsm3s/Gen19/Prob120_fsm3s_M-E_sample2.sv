`timescale 1ns/1ps

module StateA(
    input  clk,
    input  reset,
    input  in,
    output reg out,
    output reg next_state
);

reg [1:0] state;

initial state = 2'b00;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
    end else begin
        if (in) begin
            next_state <= 1'b1; // Transition to State B
        end else begin
            next_state <= 1'b0; // Stay in State A
        end
        out <= 1'b0;
    end
end

endmodule

module StateB(
    input  clk,
    input  reset,
    input  in,
    output reg out,
    output reg next_state
);

reg [1:0] state;

initial state = 2'b01;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01;
    end else begin
        if (!in) begin
            next_state <= 1'b1; // Transition to State C
        end else begin
            next_state <= 1'b0; // Stay in State B
        end
        out <= 1'b0;
    end
end

endmodule

module StateC(
    input  clk,
    input  reset,
    input  in,
    output reg out,
    output reg next_state
);

reg [1:0] state;

initial state = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b10;
    end else begin
        if (in) begin
            next_state <= 1'b1; // Transition to State D
        end else begin
            next_state <= 1'b0; // Transition to State A
        end
        out <= 1'b0;
    end
end

endmodule

module StateD(
    input  clk,
    input  reset,
    input  in,
    output reg out,
    output reg next_state
);

reg [1:0] state;

initial state = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b11;
    end else begin
        if (!in) begin
            next_state <= 1'b1; // Transition to State C
        end else begin
            next_state <= 1'b0; // Transition to State B
        end
        out <= 1'b1;
    end
end

endmodule

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state;
reg next_state_A, next_state_B, next_state_C, next_state_D;
reg out_A, out_B, out_C, out_D;

StateA state_A(clk, reset, in, out_A, next_state_A);
StateB state_B(clk, reset, in, out_B, next_state_B);
StateC state_C(clk, reset, in, out_C, next_state_C);
StateD state_D(clk, reset, in, out_D, next_state_D);

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin
                if (next_state_A) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if (next_state_B) begin
                    state <= 2'b10;
                end
            end
            2'b10: begin
                if (next_state_C) begin
                    state <= 2'b11;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b11: begin
                if (next_state_D) begin
                    state <= 2'b10;
                end else begin
                    state <= 2'b01;
                end
            end
        endcase
    end
end

assign out = (state == 2'b11)? 1'b1 : 1'b0;

endmodule