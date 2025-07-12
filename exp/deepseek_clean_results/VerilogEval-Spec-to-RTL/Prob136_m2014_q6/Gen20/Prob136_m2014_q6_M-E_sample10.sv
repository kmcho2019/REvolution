module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Custom state encoding optimized for parallel computation
    // bit[2] indicates z output (E,F)
    // bits[1:0] arranged for efficient transition logic
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101;

    reg [2:0] state;

    // Parallel next state computation
    wire [2:0] next_A = w ? A : B;
    wire [2:0] next_B = w ? D : C;
    wire [2:0] next_C = w ? D : E;
    wire [2:0] next_D = w ? A : F;
    wire [2:0] next_E = w ? D : E;
    wire [2:0] next_F = w ? D : C;

    wire [2:0] next_state;
    assign next_state = 
        (state == A) ? next_A :
        (state == B) ? next_B :
        (state == C) ? next_C :
        (state == D) ? next_D :
        (state == E) ? next_E :
        (state == F) ? next_F : A;

    // State transition with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
            state <= next_state;
            z <= next_state[2]; // Registered output for glitch-free operation
        end
    end

endmodule