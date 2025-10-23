module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

// Initialize state at reset
initial state = 0;

// Update state at positive edge of clock
always @(posedge clk) begin
    if (!a && !b) begin
        state <= 1;
    end else if (a && b) begin
        state <= 0;
    end
end

// Update q based on current inputs and state
always @(a, b, state) begin
    if (b && !state) begin
        q <= 1;
    end else if (a && !b && state) begin
        q <= 1;
    end else begin
        q <= 0;
    end
end

endmodule