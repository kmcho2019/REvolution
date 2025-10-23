module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // States: number of matched bits in "10011" sequence (0 to 4)
    reg [2:0] state, next_state;

    always @(*) begin
        if (state == 3'd0) begin
            if (IN)
                next_state = 3'd1;
            else
                next_state = 3'd0;
        end else if (state == 3'd1) begin
            if (!IN)
                next_state = 3'd2;
            else
                next_state = 3'd1;
        end else if (state == 3'd2) begin
            if (!IN)
                next_state = 3'd3;
            else
                next_state = 3'd1;
        end else if (state == 3'd3) begin
            if (IN)
                next_state = 3'd4;
            else
                next_state = 3'd0;
        end else /* state == 4 */ begin
            if (IN)
                next_state = 3'd1;
            else
                next_state = 3'd2;
        end
    end

    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // MATCH is asserted when in state 4 and IN=1, indicating sequence "10011" completion
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule