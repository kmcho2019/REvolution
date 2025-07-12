module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

// Define a BCD counter module
module bcd_counter(
    input clk,
    input reset,
    input ena,
    output [3:0] q
);
    reg [3:0] q;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            q <= 0;
        end else if(ena) begin
            if(q == 9) begin
                q <= 0;
            end else begin
                q <= q + 1;
            end
        end
    end
endmodule

// Instantiate four BCD counter modules for each digit
wire c1, c2, c3;
reg [3:0] q1, q2, q3, q4;

// Ones digit
bcd_counter u1(clk, reset, 1'b1, q1);

// Tens digit
assign c1 = (q1 == 0) ? 1'b1 : 1'b0;
bcd_counter u2(clk, reset, c1, q2);

// Hundreds digit
assign c2 = (q2 == 0 && q1 == 0) ? 1'b1 : 1'b0;
bcd_counter u3(clk, reset, c2, q3);

// Thousands digit
assign c3 = (q3 == 0 && q2 == 0 && q1 == 0) ? 1'b1 : 1'b0;
bcd_counter u4(clk, reset, c3, q4);

// Assign outputs
assign ena = {c3, c2, c1};
assign q = {q4, q3, q2, q1};

endmodule