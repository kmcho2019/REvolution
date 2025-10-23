module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    reg [1:0] state, next_state;

    localparam S0 = 2'd0, S1 = 2'd1, S2 = 2'd2;

    always @(*) begin
        z = 1'b0;
        case(state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S2;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // detected "101"
                end else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule