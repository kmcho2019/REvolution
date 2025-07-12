module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    // next_state logic from waveform analysis
    if (state) begin
        // state=1 cases
        if (~a & ~b)
            next_state = 1'b1;
        else if (a & b)
            next_state = 1'b1;
        else
            next_state = 1'b0;
    end else begin
        // state=0 cases
        if (a & ~b)
            next_state = 1'b1;
        else
            next_state = 1'b0;
    end

    // q output logic
    if (state)
        q = 1'b1;
    else
        q = a ^ b;
end

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
    q = 1'b0;
end

endmodule