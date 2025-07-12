module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    reg [2:0] state, next_state;

    // Next-state logic simplified with if-else
    always @(*) begin
        if (state == 3'd0) begin
            if (IN) next_state = 3'd1;
            else    next_state = 3'd0;
        end else if (state == 3'd1) begin
            if (!IN) next_state = 3'd2;
            else     next_state = 3'd1;
        end else if (state == 3'd2) begin
            if (!IN) next_state = 3'd3;
            else     next_state = 3'd1;
        end else if (state == 3'd3) begin
            if (IN)  next_state = 3'd4;
            else     next_state = 3'd0;
        end else if (state == 3'd4) begin
            if (IN)  next_state = 3'd1;
            else     next_state = 3'd2;
        end else begin
            next_state = 3'd0;
        end
    end

    // State register update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // MATCH asserted when in state 4 and IN=1 (Mealy output)
    assign MATCH = (state == 3'd4) && IN;

endmodule