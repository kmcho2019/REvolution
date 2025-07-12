module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // One-hot state encoding: S0=001, S1=010, S2=100
    localparam S0 = 3'b001;
    localparam S1 = 3'b010;
    localparam S2 = 3'b100;

    reg [2:0] state, next_state;

    always @(*) begin
        // Default assignments
        next_state = 3'b000;
        z = 1'b0;

        case (state)
            S0: begin
                if (x) next_state = S1;
                else   next_state = S0;
                z = 1'b0;
            end
            S1: begin
                if (x) next_state = S1;
                else   next_state = S2;
                z = 1'b0;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1;  // sequence "101" detected on Mealy output
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

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule