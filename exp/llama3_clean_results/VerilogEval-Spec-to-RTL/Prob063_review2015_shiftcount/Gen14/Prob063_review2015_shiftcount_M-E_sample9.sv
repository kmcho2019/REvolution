module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q = 4'b0
);

reg [3:0] shift_value;
reg [3:0] count_value;

always @(posedge clk) begin
    // Calculate shift value
    shift_value <= {data, q[3:1]};

    // Calculate count value
    if (q!= 4'b0) begin
        count_value <= q - 1;
    end else begin
        count_value <= q;
    end

    // Select between shift and count operations
    if (shift_ena || count_ena) begin
        if (shift_ena) begin
            q <= shift_value;
        end else begin
            q <= count_value;
        end
    end
end

endmodule