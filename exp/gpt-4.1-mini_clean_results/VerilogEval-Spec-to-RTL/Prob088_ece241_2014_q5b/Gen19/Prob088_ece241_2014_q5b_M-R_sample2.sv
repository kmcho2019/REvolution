module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_A, state_B;
wire next_state_A, next_state_B;

// Next-state logic (combinational)
always @(*) begin
    // Default assignments
    next_state_A = 1'b0;
    next_state_B = 1'b0;

    case ({state_A, state_B})
        2'b10: begin // State A
            if (x == 1'b0) begin
                next_state_A = 1'b1;
                next_state_B = 1'b0;
            end else begin
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end
        end

        2'b01: begin // State B
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end

        default: begin // Should not happen, but reset to A state safe
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end
    endcase
end

// Output logic (Mealy)
always @(*) begin
    case ({state_A, state_B})
        2'b10: z = (x == 1'b0) ? 1'b0 : 1'b1;
        2'b01: z = (x == 1'b0) ? 1'b1 : 1'b0;
        default: z = 1'b0;
    endcase
end

// Sequential logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule