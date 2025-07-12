module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding: 5 states representing progress in matching "10011"
    localparam S0 = 3'd0; // no match yet
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '10'
    localparam S3 = 3'd3; // matched '100'
    localparam S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;
    reg match_next;

    // Next state and next MATCH logic (combinational)
    always @(*) begin
        // Default assignments
        next_state = S0;
        match_next = 1'b0;

        case (state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end

            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end

            S4: begin
                if (IN == 1'b1) begin
                    next_state = S1;
                    // Complete sequence "10011" detected here at the last '1'
                    match_next = 1'b1;
                end else begin
                    next_state = S2;
                    match_next = 1'b0;
                end
            end

            default: begin
                next_state = S0;
                match_next = 1'b0;
            end
        endcase
    end

    // Sequential state and output update with synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= match_next;
        end
    end

endmodule