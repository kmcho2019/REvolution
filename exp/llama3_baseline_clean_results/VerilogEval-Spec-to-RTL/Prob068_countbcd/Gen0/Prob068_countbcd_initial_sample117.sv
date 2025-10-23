module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Internal signals
    wire [3:0] ones, tens, hundreds, thousands;
    wire ones_inc, tens_inc, hundreds_inc;

    // Assign enable signals
    assign ena[0] = (q[3:0] == 4'd9)? 1'b1 : 1'b0;
    assign ena[1] = (q[7:4] == 4'd9)? 1'b1 : 1'b0;
    assign ena[2] = (q[11:8] == 4'd9)? 1'b1 : 1'b0;

    // Instantiate counters
    BCDCounter ones_counter(clk, reset, 1'b1, ones);
    BCDCounter tens_counter(clk, reset, (q[3:0] == 4'd9)? 1'b1 : 1'b0, tens);
    BCDCounter hundreds_counter(clk, reset, (q[7:4] == 4'd9)? 1'b1 : 1'b0, hundreds);
    BCDCounter thousands_counter(clk, reset, (q[11:8] == 4'd9)? 1'b1 : 1'b0, thousands);

    // Concatenate outputs
    assign q[3:0] = ones;
    assign q[7:4] = tens;
    assign q[11:8] = hundreds;
    assign q[15:12] = thousands;

endmodule

// BCD Counter module
module BCDCounter(
    input clk,
    input reset,
    input inc,
    output [3:0] q
);

    reg [3:0] q_reg;

    always @(posedge clk) begin
        if (reset) begin
            q_reg <= 4'd0;
        end else if (inc) begin
            if (q_reg == 4'd9) begin
                q_reg <= 4'd0;
            end else begin
                q_reg <= q_reg + 1;
            end
        end
    end

    assign q = q_reg;

endmodule