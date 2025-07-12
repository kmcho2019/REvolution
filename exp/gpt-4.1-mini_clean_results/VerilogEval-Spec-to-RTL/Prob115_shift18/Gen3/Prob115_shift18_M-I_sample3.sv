module TopModule(
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // One-hot decode amount to select shift operation
    wire shift_left_1 = (amount == 2'b00);
    wire shift_left_8 = (amount == 2'b01);
    wire shift_right_1 = (amount == 2'b10);
    wire shift_right_8 = (amount == 2'b11);

    // Generate shifted candidates
    wire [63:0] shifted_left_1  = {q[62:0], 1'b0};
    wire [63:0] shifted_left_8  = {q[55:0], 8'b0};
    wire [63:0] shifted_right_1 = {q[63], q[63:1]};
    wire [63:0] shifted_right_8 = {{8{q[63]}}, q[63:8]};

    // Select shifted output using one-hot mux
    wire [63:0] shifted = ({64{shift_left_1}}  & shifted_left_1)  |
                         ({64{shift_left_8}}  & shifted_left_8)  |
                         ({64{shift_right_1}} & shifted_right_1) |
                         ({64{shift_right_8}} & shifted_right_8);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
    end

endmodule