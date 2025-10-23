`timescale 1ns/1ps

module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} states;

states current_state, next_state;

// Output logic
always_comb begin
    case(current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// State transition logic
always_ff @(posedge clk) begin
    if(reset) begin
        current_state <= A;
    end else begin
        case(current_state)
            A: begin
                if(!in) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            B: begin
                if(!in) begin
                    current_state <= C;
                end else begin
                    current_state <= B;
                end
            end
            C: begin
                if(!in) begin
                    current_state <= A;
                end else begin
                    current_state <= D;
                end
            end
            D: begin
                if(!in) begin
                    current_state <= C;
                end else begin
                    current_state <= B;
                end
            end
            default: current_state <= A;
        endcase
    end
end

endmodule