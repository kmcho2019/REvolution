module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (binary), representing matched bits of "10011"
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5;

    reg [2:0] state, next_state;
    reg match_next;

    // Next state logic using if-else to simplify combinational logic
    always @(*) begin
        // Default assignments
        next_state = S0;
        match_next = 1'b0;

        if (state == S0) begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end else if (state == S1) begin
            if (IN == 1'b0)
                next_state = S2;
            else
                next_state = S1;
        end else if (state == S2) begin
            if (IN == 1'b0)
                next_state = S3;
            else
                next_state = S1;
        end else if (state == S3) begin
            if (IN == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end else if (state == S4) begin
            if (IN == 1'b1) begin
                next_state = S5;
                match_next = 1'b1; // Sequence "10011" detected here
            end else begin
                next_state = S2;
                match_next = 1'b0;
            end
        end else if (state == S5) begin
            if (IN == 1'b0)
                next_state = S2;
            else
                next_state = S1;
            match_next = 1'b0;
        end else begin
            next_state = S0;
            match_next = 1'b0;
        end
    end

    // State and MATCH registers with synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= match_next;
        end
    end

endmodule