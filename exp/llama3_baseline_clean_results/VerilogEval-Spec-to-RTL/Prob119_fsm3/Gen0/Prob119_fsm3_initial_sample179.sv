`timescale 1ns / 1ps

module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
    );

// Enum for states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} current_state, next_state;

// Output logic
always_comb begin
    case(current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

// State transition logic
always_comb begin
    case(current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule