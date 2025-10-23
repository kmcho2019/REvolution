module TopModule(
    input       clk,
    input       reset,
    input       slowena,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_state;

always @(*) begin
    if (reset) begin
        next_state = 4'b0;
    end else if (slowena) begin
        if (count == 4'd9) begin
            next_state = 4'b0;
        end else begin
            next_state = count + 1'b1;
        end
    end else begin
        next_state = count;
    end
end

always @(posedge clk) begin
    count <= next_state;
end

assign q = count;

endmodule