module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding: number of matched bits of "10011"
    reg [2:0] state, next_state;

    always @(*) begin
        if (state == 3'd0) begin
            if (IN)
                next_state = 3'd1;
            else
                next_state = 3'd0;
        end else if (state == 3'd1) begin
            if (~IN)
                next_state = 3'd2;
            else
                next_state = 3'd1;
        end else if (state == 3'd2) begin
            if (~IN)
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

    // MATCH is high when sequence "10011" is completed, i.e., when state=4 and IN=1
    assign MATCH = (state == 3'd4) && IN;

endmodule