module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // One-hot state encoding
    localparam S_CYCLE0 = 5'b00001;
    localparam S_CYCLE1 = 5'b00010;
    localparam S_CYCLE2 = 5'b00100;
    localparam S_CYCLE3 = 5'b01000;
    localparam S_IDLE   = 5'b10000;

    reg [4:0] state;

    // Output is directly the OR of all active state bits
    assign shift_ena = |state[3:0];  // All bits except S_IDLE

    always @(posedge clk) begin
        if (reset) begin
            state <= S_CYCLE0;
        end else begin
            case (1'b1)  // Synthesis-optimized case statement
                state[0]: state <= S_CYCLE1;  // S_CYCLE0 -> S_CYCLE1
                state[1]: state <= S_CYCLE2;   // S_CYCLE1 -> S_CYCLE2
                state[2]: state <= S_CYCLE3;   // S_CYCLE2 -> S_CYCLE3
                state[3]: state <= S_IDLE;     // S_CYCLE3 -> S_IDLE
                state[4]: state <= S_IDLE;     // S_IDLE stays
                default:  state <= S_IDLE;     // Handle power-up
            endcase
        end
    end

endmodule