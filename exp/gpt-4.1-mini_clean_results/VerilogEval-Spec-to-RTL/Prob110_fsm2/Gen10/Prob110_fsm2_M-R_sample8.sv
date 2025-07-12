module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire j,
    input  wire k,
    output reg  out
);

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state, next_state;

// Next-state combinational logic
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

// State sequential logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Output registered Moore output, synchronous reset to 0
always @(posedge clk) begin
    if (areset) begin
        out <= 1'b0;
    end else begin
        out <= (state == ON);
    end
end

endmodule