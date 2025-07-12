module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001; // initialize LSB to 1
        end else begin
            out <= {out[6:0], out[7]}; // left rotate by 1 bit
        end
    end

endmodule