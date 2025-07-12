`timescale 1ns/1ps

module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define states as enum values
typedef enum logic [0:0] {
    OFF,
    ON
} state_t;

// Current state register
reg state_t current_state;

// Next state logic
always_comb begin
    case(current_state)
        OFF: begin
            if (~j) begin
                current_state = OFF;
            end else begin
                current_state = ON;
            end
        end
        ON: begin
            if (~k) begin
                current_state = ON;
            end else begin
                current_state = OFF;
            end
        end
    endcase
end

// Update current state on rising edge of clock
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        case(current_state)
            OFF: begin
                if (~j) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
            ON: begin
                if (~k) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
        endcase
    end
end

// Output logic (Moore output)
always_comb begin
    case(current_state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
    endcase
end

endmodule