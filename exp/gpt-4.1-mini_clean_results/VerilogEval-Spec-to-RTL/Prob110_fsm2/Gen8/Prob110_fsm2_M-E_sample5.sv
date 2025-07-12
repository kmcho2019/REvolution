module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire j,
    input  wire k,
    output wire out
);

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state, next_state;

// Next-state combinational logic (if-else)
always @(*) begin
    if (state == OFF) begin
        if (j)
            next_state = ON;
        else
            next_state = OFF;
    end else begin // state == ON
        if (k)
            next_state = OFF;
        else
            next_state = ON;
    end
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

// Output combinational logic: Moore output depends only on state
assign out = (state == ON);

endmodule