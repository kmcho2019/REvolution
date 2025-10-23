module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg [1:0] state, next_state;

    // State encoding
    localparam S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10,
               S3 = 2'b11;

    // Next state and output logic (combinational)
    always @(*) begin
        case (state)
            S0: begin
                if (a)
                    next_state = S1;
                else
                    next_state = S0;
                // Outputs reflect next_state but registered later
            end
            S1: begin
                if (a)
                    next_state = S3;
                else
                    next_state = S0;
            end
            S3: begin
                if (a)
                    next_state = S3;
                else
                    next_state = S2;
            end
            S2: begin
                if (a)
                    next_state = S3;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // State update and output registers on positive clock edge
    always @(posedge clock) begin
        state <= next_state;
        // Outputs p and q follow the state bits
        p <= next_state[0];
        q <= next_state[1];
    end

    // Initialize state and outputs
    initial begin
        state = S0;
        p = 0;
        q = 0;
    end

endmodule