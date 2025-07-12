module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    wire shift_en = shift_ena;
    wire count_en = count_ena & ~shift_ena; // mutually exclusive enables

    reg [3:0] next_q;

    // Compute next state combinationally with mutually exclusive controls
    always @(*) begin
        if (shift_en)
            next_q = {q[2:0], data}; // shift in data at LSB, MSB first shift
        else if (count_en)
            next_q = q - 1;          // decrement by 1 modulo 16
        else
            next_q = q;              // hold current value
    end

    // Register update on clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule