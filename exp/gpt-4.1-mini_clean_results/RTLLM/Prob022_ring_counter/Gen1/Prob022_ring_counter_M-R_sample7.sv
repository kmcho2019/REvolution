module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'd0;
        end else begin
            count <= count + 3'd1;
        end
    end

    always @(*) begin
        out = 8'b0000_0001 << count;
    end

endmodule