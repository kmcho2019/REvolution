module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using localparams
    localparam S0 = 2'd0; // no bits matched
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched '10'

    reg [1:0] state, next_state;
    reg next_z;

    // State register with async negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

    // Combinational next state and output logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_z = 1'b0;

        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (!x)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    next_z = 1'b1; // sequence "101" detected
                end else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
                next_z = 1'b0;
            end
        endcase
    end

endmodule