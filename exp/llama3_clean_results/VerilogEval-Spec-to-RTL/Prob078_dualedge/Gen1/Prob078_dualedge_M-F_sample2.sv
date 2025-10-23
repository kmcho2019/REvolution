module TopModule(
    input clk,
    input d,
    output reg q
);

reg t_ff_q_correct; // T flip-flop output
reg prev_d; // Previous value of d

// T flip-flop to generate a toggling signal at every clock edge
always @(posedge clk) begin
    t_ff_q_correct <= ~t_ff_q_correct;
end

always @(negedge clk) begin
    t_ff_q_correct <= ~t_ff_q_correct;
end

// Capture the input d into a flip-flop on the rising edge of clk
always @(posedge clk) begin
    prev_d <= d;
end

// Use the toggling signal to select between the current and previous values of d
always @(posedge t_ff_q_correct) begin
    if (t_ff_q_correct) begin
        q <= d;
    end else begin
        q <= prev_d;
    end
end

endmodule