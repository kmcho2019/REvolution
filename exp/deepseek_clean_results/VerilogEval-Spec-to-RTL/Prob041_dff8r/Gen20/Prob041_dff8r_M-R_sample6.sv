module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Individual flip-flop registers
    reg q_0, q_1, q_2, q_3, q_4, q_5, q_6, q_7;

    // Continuous assignments for each flip-flop
    assign q[0] = q_0;
    assign q[1] = q_1;
    assign q[2] = q_2;
    assign q[3] = q_3;
    assign q[4] = q_4;
    assign q[5] = q_5;
    assign q[6] = q_6;
    assign q[7] = q_7;

    // Flip-flop behavior using continuous assignments
    always @(posedge clk) begin
        q_0 <= reset ? 1'b0 : d[0];
        q_1 <= reset ? 1'b0 : d[1];
        q_2 <= reset ? 1'b0 : d[2];
        q_3 <= reset ? 1'b0 : d[3];
        q_4 <= reset ? 1'b0 : d[4];
        q_5 <= reset ? 1'b0 : d[5];
        q_6 <= reset ? 1'b0 : d[6];
        q_7 <= reset ? 1'b0 : d[7];
    end

endmodule