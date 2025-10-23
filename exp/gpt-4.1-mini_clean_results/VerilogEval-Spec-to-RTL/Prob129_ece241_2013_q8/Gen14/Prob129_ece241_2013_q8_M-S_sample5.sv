module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    localparam S0 = 2'd0; // no bits matched
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    next_state = x ? S1 : S0;
                    z <= 1'b0;
                end
                S1: begin
                    next_state = x ? S1 : S2;
                    z <= 1'b0;
                end
                S2: begin
                    next_state = x ? S1 : S0;
                    z <= x; // detect '101'
                end
                default: begin
                    next_state = S0;
                    z <= 1'b0;
                end
            endcase
            state <= next_state;
        end
    end

endmodule