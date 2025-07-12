module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Compute next values combinationally
    wire [3:0] shift_val = {q[2:0], data}; // shift left by 1, MSB-first insert data at LSB
    wire [3:0] count_val = q - 1;

    // Priority mux selects next state
    wire [3:0] next_q = shift_ena ? shift_val :
                       count_ena ? count_val :
                       q; // hold if neither enabled

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule