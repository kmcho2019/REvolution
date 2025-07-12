module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
    if (a == 1 && prev_a == 0) begin
        q <= ~q;  // toggle q when a transitions from 0 to 1
    end
end

initial begin
    prev_a = 0;  // initialize prev_a to 0
    q = 1;       // initialize q to 1 based on the waveform
end

endmodule