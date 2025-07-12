module TopModule (
    input clk,
    input a,
    output reg q
);

reg a_prev;
wire a_rising;

// Edge detection logic
always @(posedge clk) begin
    a_prev <= a;
end
assign a_rising = ~a_prev & a;

// State machine that toggles on rising edges of a
always @(posedge clk) begin
    if (a_rising) begin
        q <= ~q;
    end
    else begin
        q <= q;
    end
end

// Initial condition to match waveform
initial begin
    q = 1'b1;
    a_prev = 1'b0;
end

endmodule