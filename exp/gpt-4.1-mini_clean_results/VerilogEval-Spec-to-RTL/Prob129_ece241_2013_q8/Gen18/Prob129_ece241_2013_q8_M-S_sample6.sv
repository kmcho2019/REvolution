module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    typedef enum logic [1:0] {S0=2'd0, S1=2'd1, S2=2'd2} state_t;
    state_t state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case(state)
                S0: begin
                    z <= 1'b0;
                    state <= x ? S1 : S0;
                end
                S1: begin
                    z <= 1'b0;
                    state <= x ? S1 : S2;
                end
                S2: begin
                    z <= x ? 1'b1 : 1'b0; // output asserted when input x=1 in S2
                    state <= x ? S1 : S0;
                end
                default: begin
                    z <= 1'b0;
                    state <= S0;
                end
            endcase
        end
    end

endmodule