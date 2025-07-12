module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        out <= 1; // Initialize out with the least significant bit set
    end else begin
        counter <= (counter == 7)? 0 : counter + 1;
        case (counter)
            3'd0: out <= 8'b0000_0001;
            3'd1: out <= 8'b0000_0010;
            3'd2: out <= 8'b0000_0100;
            3'd3: out <= 8'b0000_1000;
            3'd4: out <= 8'b0001_0000;
            3'd5: out <= 8'b0010_0000;
            3'd6: out <= 8'b0100_0000;
            3'd7: out <= 8'b1000_0000;
        endcase
    end
end

endmodule