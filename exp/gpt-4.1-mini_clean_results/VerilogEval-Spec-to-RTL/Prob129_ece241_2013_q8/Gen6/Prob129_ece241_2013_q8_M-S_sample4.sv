module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] state, next_state;

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        z = 1'b0;
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1;
                end else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule