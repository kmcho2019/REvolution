module ring_counter (
    input  clk,
    input  reset,
    output [7:0] out
);

    reg [7:0] state;

    assign out = state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'b0000_0001; // Initialize with LSB high
        end else begin
            if (state[7] == 1'b1)
                state <= 8'b0000_0001; // wrap back to LSB when MSB was set
            else
                state <= state << 1;   // shift left by 1
        end
    end

endmodule