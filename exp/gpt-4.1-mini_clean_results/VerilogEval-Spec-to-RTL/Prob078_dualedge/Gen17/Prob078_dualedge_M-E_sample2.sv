module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg d_pos, d_neg;  // sampled inputs on edges

    // Sample input 'd' on positive edge of clk
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Sample input 'd' on negative edge of clk
    always @(negedge clk) begin
        d_neg <= d;
    end

    wire change_pos = d_pos ^ q;  // detect change on positive edge sampled data
    wire change_neg = d_neg ^ q;  // detect change on negative edge sampled data

    // At every clock edge, toggle output 'q' if input 'd' changed since last toggle
    // Use separate flip-flops clocked on posedge and negedge to trigger toggles

    reg toggle_pos, toggle_neg;

    always @(posedge clk) begin
        toggle_pos <= change_pos;
    end

    always @(negedge clk) begin
        toggle_neg <= change_neg;
    end

    // Combine toggles from posedge and negedge logic to update q
    // q toggles if either toggle_pos or toggle_neg is high at corresponding edges

    // Since we cannot assign q at both posedge and negedge in one always,
    // we will combine the toggle signals and update q on both edges through a separate process

    reg q_next;
    always @(posedge clk or negedge clk) begin
        if ( (clk && toggle_pos) || (!clk && toggle_neg) )
            q <= ~q;
    end

endmodule