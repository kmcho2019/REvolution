module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding (2 bits)
    localparam S0 = 2'd0; // no bits matched
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // State register with asynchronous negedge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic combined
    always @(*) begin
        case(state)
            S0: begin
                next_state = x ? S1 : S0;
                z = 1'b0;
            end
            S1: begin
                next_state = x ? S1 : S2;
                z = 1'b0;
            end
            S2: begin
                next_state = x ? S1 : S0;
                z = x; // output 1 if x=1 on S2 (detect '101')
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule