module TopModule(clk, shift_ena, count_ena, data, q);
    input clk, shift_ena, count_ena, data;
    output [3:0] q;
    reg [3:0] q;

    always @(posedge clk) begin
        if (shift_ena) begin
            q = {data, q[3:1]};
        end else if (count_ena) begin
            if (q == 0) begin
                q = 0;  // or we can also set it to a specific value, e.g., q = 4'b1111;
            end else begin
                q = q - 1;
            end
        end
    end
endmodule