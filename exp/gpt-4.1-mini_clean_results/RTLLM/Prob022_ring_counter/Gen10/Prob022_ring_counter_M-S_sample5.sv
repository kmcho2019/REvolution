module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] pos;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pos <= 3'd0;
            out <= 8'b00000001;
        end else begin
            pos <= pos + 1;
            out <= 8'b00000001 << (pos + 1);
        end
    end

endmodule