module fsm(
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

// State encoding
localparam S0 = 3'd0; // no match yet
localparam S1 = 3'd1; // matched '1'
localparam S2 = 3'd2; // matched '10'
localparam S3 = 3'd3; // matched '100'
localparam S4 = 3'd4; // matched '1001'

reg [2:0] state, next_state;
reg       match_next;

// Next state and output logic (combinational)
always @(*) begin
    // Default assignments
    next_state = S0;
    match_next = 1'b0;

    case (state)
        S0: begin
            if (IN)
                next_state = S1;
            else
                next_state = S0;
            match_next = 1'b0;
        end

        S1: begin
            if (IN == 1'b0)
                next_state = S2;
            else // IN == 1
                next_state = S1;
            match_next = 1'b0;
        end

        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else // IN == 1
                next_state = S1;
            match_next = 1'b0;
        end

        S3: begin
            if (IN)
                next_state = S4;
            else
                next_state = S0;
            match_next = 1'b0;
        end

        S4: begin
            if (IN) begin
                next_state = S1;
                match_next = 1'b1; // sequence 10011 matched here
            end else begin // IN == 0
                next_state = S2;  // partial match "10" after "1001" + '0'
                match_next = 1'b1; // also sequence matched here
            end
        end

        default: begin
            next_state = S0;
            match_next = 1'b0;
        end
    endcase
end

// State and MATCH update (synchronous)
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