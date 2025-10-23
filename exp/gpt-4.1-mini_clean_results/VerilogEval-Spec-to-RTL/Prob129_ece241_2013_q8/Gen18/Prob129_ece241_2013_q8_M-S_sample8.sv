module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
    reg [1:0] state, next_state;

    always @(*) begin
        z = 0;
        case (state)
            S0: begin
                next_state = x ? S1 : S0;
            end
            S1: begin
                next_state = x ? S1 : S2;
            end
            S2: begin
                next_state = x ? S1 : S0;
                z = x; // output asserted when x=1 at state S2 (detect "101")
            end
            default: begin
                next_state = S0;
                z = 0;
            end
        endcase
    end

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule