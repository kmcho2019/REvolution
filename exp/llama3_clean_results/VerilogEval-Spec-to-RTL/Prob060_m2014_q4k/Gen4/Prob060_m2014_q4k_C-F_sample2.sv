module TopModule (
    input       clk,
    input       resetn,
    input       in,
    output      out
);

reg [3:0] data;

always_ff @(posedge clk) begin
    if (!resetn) begin
        for (int i = 0; i < 4; i++) begin
            data[i] <= 1'b0;
        end
    end else begin
        for (int i = 3; i > 0; i--) begin
            data[i] <= data[i-1];
        end
        data[0] <= in;
    end
end

assign out = data[3];

endmodule