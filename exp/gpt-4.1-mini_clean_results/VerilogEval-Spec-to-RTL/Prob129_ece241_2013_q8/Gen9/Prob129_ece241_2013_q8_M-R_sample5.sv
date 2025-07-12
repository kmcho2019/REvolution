module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    localparam S_IDLE = 2'd0;
    localparam S_1    = 2'd1;
    localparam S_10   = 2'd2;

    reg [1:0] state, next_state;

    // Next state combinational logic using ternary operators
    assign next_state = (state == S_IDLE) ? (x ? S_1 : S_IDLE) :
                        (state == S_1)    ? (x ? S_1 : S_10) :
                                            (x ? S_1 : S_IDLE);

    // Sequential block: state update and registered Mealy output
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S_IDLE;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Mealy output: detect "101" when in S_10 and x==1 at current clock
            z <= (state == S_10) && x;
        end
    end

endmodule