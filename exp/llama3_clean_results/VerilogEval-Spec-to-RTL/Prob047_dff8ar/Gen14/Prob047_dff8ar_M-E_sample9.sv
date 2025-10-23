// 1-bit D Flip-Flop module with active high asynchronous reset
module DFF_1bit(
    input           clk,
    input           areset,
    input           d,
    output          q
);

    // Use a reg to hold the output value
    reg q_reg;

    // Always block triggered on positive edge of clk or posedge of areset
    always @(posedge clk or posedge areset) begin
        // If areset is high, reset q_reg to 0
        if (areset) begin
            q_reg <= 1'b0;
        end 
        // Otherwise, update q_reg with the input d on the positive edge of clk
        else begin
            q_reg <= d;
        end
    end

    // Continuous assignment to output q
    assign q = q_reg;

endmodule

// TopModule with eight 1-bit D Flip-Flops
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate eight DFF_1bit modules
    DFF_1bit dff0(.clk(clk), .areset(areset), .d(d[0]), .q(q[0]));
    DFF_1bit dff1(.clk(clk), .areset(areset), .d(d[1]), .q(q[1]));
    DFF_1bit dff2(.clk(clk), .areset(areset), .d(d[2]), .q(q[2]));
    DFF_1bit dff3(.clk(clk), .areset(areset), .d(d[3]), .q(q[3]));
    DFF_1bit dff4(.clk(clk), .areset(areset), .d(d[4]), .q(q[4]));
    DFF_1bit dff5(.clk(clk), .areset(areset), .d(d[5]), .q(q[5]));
    DFF_1bit dff6(.clk(clk), .areset(areset), .d(d[6]), .q(q[6]));
    DFF_1bit dff7(.clk(clk), .areset(areset), .d(d[7]), .q(q[7]));

endmodule