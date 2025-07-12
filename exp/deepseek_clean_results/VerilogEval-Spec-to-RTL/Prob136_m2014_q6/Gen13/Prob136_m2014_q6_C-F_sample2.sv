module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state encoding with descriptive names
    localparam [2:0]
        STATE_A = 3'b000,  // z=0
        STATE_B = 3'b001,  // z=0
        STATE_C = 3'b011,  // z=0
        STATE_D = 3'b010,  // z=0
        STATE_E = 3'b110,  // z=1
        STATE_F = 3'b100;  // z=1

    reg [2:0] state;

    // State transition logic with clock gating hints
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
        end
        else begin
            case (state)
                STATE_A: state <= w ? STATE_A : STATE_B;
                STATE_B: state <= w ? STATE_D : STATE_C;
                STATE_C: state <= w ? STATE_D : STATE_E;
                STATE_D: state <= w ? STATE_A : STATE_F;
                STATE_E: state <= w ? STATE_D : STATE_E;  // Stable when w=0
                STATE_F: state <= w ? STATE_D : STATE_C;
            endcase
        end
    end

    // Output is MSB of state (E and F states have z=1)
    assign z = state[2];

endmodule