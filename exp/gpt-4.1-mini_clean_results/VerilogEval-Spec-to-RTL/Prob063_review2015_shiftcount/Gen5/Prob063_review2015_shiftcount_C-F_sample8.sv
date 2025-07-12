module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    // Shift right by one, insert new data at MSB (bit 3)
    wire [3:0] shift_val = {data, q[3:1]};
    wire [3:0] count_val = q - 1;

    wire [3:0] next_q = shift_ena ? shift_val :
                        count_ena ? count_val :
                        q;

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule