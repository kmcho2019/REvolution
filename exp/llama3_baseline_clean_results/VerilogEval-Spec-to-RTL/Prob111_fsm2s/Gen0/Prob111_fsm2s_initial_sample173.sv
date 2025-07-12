`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Enum to define states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic
always_comb begin
    case (state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'bx;
    endcase
end

// State transition logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF;
        endcase
    end
end

endmodule