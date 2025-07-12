module fsm (
    input       IN,
    input       CLK,
    input       RST,
    output reg  MATCH
);

// State encoding
localparam S0 = 3'd0; // initial state
localparam S1 = 3'd1; // detected '1'
localparam S2 = 3'd2; // detected '10'
localparam S3 = 3'd3; // detected '100'
localparam S4 = 3'd4; // detected '1001'

// current state register
reg [2:0] state, next_state;

always @(*) begin
    // Default MATCH to 0; MATCH is Mealy output dependent on state and input
    MATCH = 1'b0;
    case(state)
        S0: begin
            if (IN == 1'b1)      next_state = S1;
            else                 next_state = S0;
        end
        S1: begin
            if (IN == 1'b0)      next_state = S2;
            else                 next_state = S1;
        end
        S2: begin
            if (IN == 1'b0)      next_state = S3;
            else                 next_state = S1;
        end
        S3: begin
            if (IN == 1'b1)      next_state = S4;
            else                 next_state = S0;
        end
        S4: begin
            if (IN == 1'b1) begin
                next_state = S1;
                MATCH = 1'b1;  // Sequence detected on IN=1 at S4 with IN=1 input
            end
            else begin
                next_state = S2;
                MATCH = 1'b0;
            end
        end
        default: begin
            next_state = S0;
            MATCH = 1'b0;
        end
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // MATCH is combinational Mealy output, but to hold it at clock edge, update it here as well
        // It was set in combinational logic above, so replicate it here:
        if (state == S4 && IN == 1'b1)
            MATCH <= 1'b1;
        else
            MATCH <= 1'b0;
    end
end

endmodule