module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Internal signals to connect the four BCD counters
    wire [3:0] q0, q1, q2, q3;
    wire [2:0] ena_int;

    // Instantiate the BCD counter modules
    BCDCounter bcd0(.clk(clk), .reset(reset), .ena(1'b1), .q(q0));
    BCDCounter bcd1(.clk(clk), .reset(reset), .ena(q0[3]), .q(q1));
    BCDCounter bcd2(.clk(clk), .reset(reset), .ena(q1[3]), .q(q2));
    BCDCounter bcd3(.clk(clk), .reset(reset), .ena(q2[3]), .q(q3));

    // Assign the enable signals
    assign ena[0] = q0[3];
    assign ena[1] = q1[3];
    assign ena[2] = q2[3];

    // Concatenate the BCD counter outputs
    assign q = {q3, q2, q1, q0};

endmodule

// Define the BCDCounter module
module BCDCounter(
    input clk,
    input reset,
    input ena,
    output [3:0] q
);

    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'd0;
        end else if (ena) begin
            if (count == 4'd9) begin
                count <= 4'd0;
            end else begin
                count <= count + 1;
            end
        end
    end

    assign q = count;

endmodule