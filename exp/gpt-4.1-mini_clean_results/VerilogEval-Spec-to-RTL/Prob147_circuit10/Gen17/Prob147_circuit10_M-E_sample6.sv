module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    // Next state logic based on waveform analysis:
    // When state=0:
    //   next_state=1 if a=1 & b=0
    // When state=1:
    //   next_state=0 if (a=1 & b=1) or (a=0 & b=0)
    // Otherwise, hold state
    if (state == 1'b0) begin
        if (a & ~b)
            next_state = 1'b1;
        else
            next_state = 1'b0;
    end else begin // state==1
        if ((a & b) | (~a & ~b))
            next_state = 1'b0;
        else
            next_state = 1'b1;
    end

    // Output logic q:
    // q=1 when state=1 except when a=1,b=1 (q=0)
    // q=1 also if state=0 and a=1,b=1
    // Else q=0
    if (state) begin
        if (a & b)
            q = 1'b0;
        else
            q = 1'b1;
    end else begin
        if (a & b)
            q = 1'b1;
        else
            q = 1'b0;
    end
end

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
    q = 1'b0;
end

endmodule