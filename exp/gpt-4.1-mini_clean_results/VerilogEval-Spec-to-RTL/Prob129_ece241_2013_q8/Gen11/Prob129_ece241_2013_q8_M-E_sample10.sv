module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // Gray coded states (2 bits)
    // S0 = 2'b00: no bits matched
    // S1 = 2'b01: matched '1'
    // S2 = 2'b11: matched "10"
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b11;

    reg [1:0] state, next_state;

    // State register with asynchronous negedge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state and output logic combined (Mealy FSM)
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
                if (x) begin
                    next_state = S1;
                    z = 1'b0;
                end else begin
                    next_state = S2;
                    z = 1'b0;
                end
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // detected "101"
                end else begin
                    next_state = S0;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule