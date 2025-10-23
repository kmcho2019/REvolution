module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to track the position of the '1' bit

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter and the output
        counter <= 0;
        out <= 8'b0000_0001;
    end else begin
        // Increment the counter and wrap around if necessary
        if (counter == 7) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
        // Generate the output based on the counter value
        case (counter)
            0: out <= 8'b0000_0001;
            1: out <= 8'b0000_0010;
            2: out <= 8'b0000_0100;
            3: out <= 8'b0000_1000;
            4: out <= 8'b0001_0000;
            5: out <= 8'b0010_0000;
            6: out <= 8'b0100_0000;
            7: out <= 8'b1000_0000;
        endcase
    end
end

endmodule