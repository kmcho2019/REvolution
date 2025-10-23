module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            q[3] <= data;
            q[2] <= q[3];
            q[1] <= q[2];
            q[0] <= q[1];
        end
        else if (count_ena) begin
            q <= q - 4'b0001;
        end
        // else q holds its value
    end

endmodule