module TopModule (
    input  clk,
    input  aresetn,  // active low synchronous reset
    input  x,
    output reg z
);

    // State encoding: 3 states encoded in 2 bits
    localparam [1:0]
        S0 = 2'b00,  // no bits matched yet
        S1 = 2'b01,  // matched '1'
        S2 = 2'b10;  // matched "10"

    reg [1:0] state, next_state;
    reg       z_next;

    // Next-state logic: combinational with default next_state assignment
    always @(*) begin
        case(state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Mealy output logic combinational (before registering)
    always @(*) begin
        z_next = (state == S2) && x;
    end

    // Synchronous active-low reset, state and output update on posedge clk
    always @(posedge clk) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;
        end
    end

endmodule