module TopModule(
    input clk,
    input a,
    input b,
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    reg [1:0] state;
    reg [1:0] next_state;
    reg internal_xor;

    always @(posedge clk) begin
        case (state)
            2'b00: begin // Idle state
                if (a == 1'b1 || b == 1'b1) begin
                    next_state <= 2'b01; // Transition to calculation state
                end else begin
                    next_state <= 2'b00; // Stay in idle state
                end
            end
            2'b01: begin // Calculation state
                internal_xor <= a ^ b;
                out_assign <= internal_xor;
                out_always_comb <= internal_xor;
                next_state <= 2'b00; // Transition back to idle state
            end
            default: next_state <= 2'b00;
        endcase

        state <= next_state;
        out_always_ff <= internal_xor; // Update out_always_ff on the rising edge of the clock
    end

endmodule