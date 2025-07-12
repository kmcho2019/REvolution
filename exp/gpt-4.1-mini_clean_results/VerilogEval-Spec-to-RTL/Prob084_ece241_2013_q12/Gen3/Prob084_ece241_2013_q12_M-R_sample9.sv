module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
    wire [2:0] sel = {A, B, C};

    // Next-state signals for each flip-flop
    wire d0 = S;
    wire d1 = Q0;
    wire d2 = Q1;
    wire d3 = Q2;
    wire d4 = Q3;
    wire d5 = Q4;
    wire d6 = Q5;
    wire d7 = Q6;

    always @(posedge clk) begin
        if (enable) begin
            Q0 <= d0;
            Q1 <= d1;
            Q2 <= d2;
            Q3 <= d3;
            Q4 <= d4;
            Q5 <= d5;
            Q6 <= d6;
            Q7 <= d7;
        end
    end

    // Concatenate Q bits into a vector for muxing
    wire [7:0] Q_vec = {Q7, Q6, Q5, Q4, Q3, Q2, Q1, Q0};

    assign Z = Q_vec[sel];

endmodule