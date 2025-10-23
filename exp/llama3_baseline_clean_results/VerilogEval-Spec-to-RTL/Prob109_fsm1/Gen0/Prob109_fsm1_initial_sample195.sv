`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states of the Moore machine
enum {A, B} state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// State transition logic
always @(*) begin
    case (state)
        A: begin
            if (!in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        A: out = 0;
        B: out = 1;
    endcase
end

endmodule