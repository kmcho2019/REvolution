module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    wire ena = shift_ena | count_ena;

    always @(posedge clk) begin
        if (ena) begin
            if (shift_ena)
                q <= {q[2:0], data};
            else // count_ena assumed mutually exclusive with shift_ena
                q <= q - 4'd1;
        end
    end

endmodule