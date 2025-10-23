module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    wire [3:0] shift_val = {q[2:0], data};
    wire [3:0] count_val = q - 4'd1;
    wire update_ena = shift_ena | count_ena;

    always @(posedge clk) begin
        if (shift_ena)
            q <= shift_val;
        else if (count_ena)
            q <= count_val;
        else
            q <= q;  // no change, to avoid unnecessary toggling
    end

endmodule