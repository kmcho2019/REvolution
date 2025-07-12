module TopModule(
    input clk,
    input d,
    output reg q
);

reg [1:0] phase; // Phase of the clock (0, 1, 2, 3)
reg q_ff; // Output of the flip-flop

// Clock phase generator (divide by 4)
always @(posedge clk) begin
    phase <= phase + 1;
end

// Single flip-flop that samples input data on both phases of the clock
always @(posedge clk) begin
    case (phase)
        0, 2: q_ff <= d; // Sample data on both phases
    endcase
end

// Output assignment
assign q = q_ff;

endmodule