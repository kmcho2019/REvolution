module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding using localparams
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state;
    wire [1:0] bumps = {bump_left, bump_right};

    // Next state combinational logic expressed as continuous assignment
    wire next_state = (bumps == 2'b00) ? state :
                      (bumps == 2'b01) ? WALK_LEFT :
                      (bumps == 2'b10) ? WALK_RIGHT :
                      ~state; // bumps == 2'b11

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs driven from state (Moore FSM)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule