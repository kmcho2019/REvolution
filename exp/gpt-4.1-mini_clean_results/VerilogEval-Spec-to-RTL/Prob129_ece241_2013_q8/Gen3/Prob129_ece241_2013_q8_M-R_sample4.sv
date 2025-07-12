module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'b00, // initial state, no bits matched
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched '10'
    } state_t;

    state_t state, next_state;

    // Next state combinational logic using assign
    // This implements Mealy state transitions (next_state depends on current state and x)
    wire next_state0, next_state1;
    assign {next_state1, next_state0} = (state == S0) ? (x ? S1 : S0) :
                                       (state == S1) ? (!x ? S2 : S1) :
                                       (state == S2) ? (x ? S1 : S0) :
                                       S0;

    // Output combinational logic for z (Mealy output)
    wire z_comb = (state == S2) && (x == 1'b1);

    // Sequential logic: state update and registered output update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_comb;
        end
    end

endmodule