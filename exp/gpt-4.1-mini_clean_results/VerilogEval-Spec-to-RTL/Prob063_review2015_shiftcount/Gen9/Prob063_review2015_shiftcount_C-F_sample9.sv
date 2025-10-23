module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    wire [3:0] shift_val = {q[2:0], data}; // MSB-first shift in data at LSB
    wire [3:0] count_val = q - 4'b0001;    // decrement by 1

    reg [3:0] next_q;

    always @(*) begin
        if (shift_ena)
            next_q = shift_val;
        else if (count_ena)
            next_q = count_val;
        else
            next_q = q;
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule