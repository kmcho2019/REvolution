module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding (A=0001, B=0010, C=0100, D=1000)
    reg [3:0] state;

    // Next state calculation for each state in parallel
    wire [3:0] next_A = {1'b0, in, 2'b00};       // A -> A(0001) or B(0010)
    wire [3:0] next_B = {1'b0, in, ~in, 1'b0};   // B -> C(0100) or B(0010)
    wire [3:0] next_C = {in, 2'b00, ~in};        // C -> A(0001) or D(1000)
    wire [3:0] next_D = {1'b0, in, ~in, 1'b0};   // D -> C(0100) or B(0010)

    // Mux to select the correct next state based on current state
    wire [3:0] next_state = 
        (state[0] ? next_A : 4'b0) |
        (state[1] ? next_B : 4'b0) |
        (state[2] ? next_C : 4'b0) |
        (state[3] ? next_D : 4'b0);

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= 4'b0001;  // Reset to state A (0001)
        else
            state <= next_state;
    end

    // Output is simply the D state bit (1000)
    assign out = state[3];

endmodule