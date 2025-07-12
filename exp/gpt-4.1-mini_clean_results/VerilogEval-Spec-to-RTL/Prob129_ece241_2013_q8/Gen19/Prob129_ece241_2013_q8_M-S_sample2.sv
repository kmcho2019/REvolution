module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    localparam S0 = 2'd0, // no match
               S1 = 2'd1, // matched '1'
               S2 = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case(state)
                S0: begin
                    z <= 1'b0;
                    if (x)
                        next_state = S1;
                    else
                        next_state = S0;
                end
                S1: begin
                    z <= 1'b0;
                    if (x)
                        next_state = S1;
                    else
                        next_state = S2;
                end
                S2: begin
                    z <= x;         // z=1 if x==1 at this state (detect "101")
                    next_state = x ? S1 : S0;
                end
                default: begin
                    z <= 1'b0;
                    next_state = S0;
                end
            endcase
            state <= next_state;
        end
    end

endmodule