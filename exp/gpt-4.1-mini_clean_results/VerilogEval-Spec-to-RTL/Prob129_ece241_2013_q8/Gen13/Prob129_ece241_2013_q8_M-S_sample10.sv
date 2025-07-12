module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    parameter S0 = 2'd0; // no match
    parameter S1 = 2'd1; // matched '1'
    parameter S2 = 2'd2; // matched "10"

    reg [1:0] state;

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
                    z <= x;        // output 1 if x=1 (detect '101')
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