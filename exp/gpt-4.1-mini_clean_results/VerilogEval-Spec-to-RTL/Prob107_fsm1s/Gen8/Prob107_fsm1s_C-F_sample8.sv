module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) 
            state <= B;
        else 
            state <= next_state;
    end

    // Next state combinational logic using clear if-else structure
    always @(*) begin
        if (state == B) begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = B;
        end else begin // state == A
            if (in == 1'b0)
                next_state = B;
            else
                next_state = A;
        end
    end

    // Moore output driven directly by state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule