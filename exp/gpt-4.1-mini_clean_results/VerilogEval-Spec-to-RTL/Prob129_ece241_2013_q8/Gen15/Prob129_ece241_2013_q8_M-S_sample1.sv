module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding: 3 states for sequence "101"
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    reg [1:0] state, next_state;

    always @(*) begin
        z = 0;
        case(state)
            S0: begin
                next_state = x ? S1 : S0;
            end
            S1: begin
                next_state = x ? S1 : S2;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1;
                end else begin
                    next_state = S0;
                end
            end
            default: begin
                next_state = S0;
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