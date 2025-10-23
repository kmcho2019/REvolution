module fsm(
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (one-hot or binary)
    // States correspond to how many bits matched of "1 0 0 1 1"
    // S0: no bits matched
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4;

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case(state)
            S0: begin
                if(IN == 1'b1) 
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if(IN == 1'b0)
                    next_state = S2;
                else // IN==1
                    next_state = S1; // stay, possible overlapping start
            end
            S2: begin
                if(IN == 1'b0)
                    next_state = S3;
                else // IN==1
                    next_state = S1; // restart matching from first '1'
            end
            S3: begin
                if(IN == 1'b1)
                    next_state = S4;
                else // IN==0
                    next_state = S0;
            end
            S4: begin
                // After matching 1 0 0 1, check input:
                // The next bit after matched '1001' is IN
                // If IN==1, sequence completes (1 0 0 1 1)
                // On that input MATCH asserted
                if(IN == 1'b1)
                    next_state = S1; // overlapping detection: last '1' can be start
                else // IN==0
                    next_state = S2; // sequence could restart from second bit matched ('10')
            end
            default: next_state = S0;
        endcase
    end

    // MATCH output combinational: asserted when the current state is S4 and IN=1, i.e., sequence matched at last input
    assign MATCH = (state == S4) && (IN == 1'b1);

    // Sequential state update with asynchronous reset
    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

endmodule