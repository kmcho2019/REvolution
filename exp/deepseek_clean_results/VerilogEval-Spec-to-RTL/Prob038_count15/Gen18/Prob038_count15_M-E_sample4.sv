module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] counter;

// Custom LFSR-style feedback for binary counting sequence
wire feedback = ~(counter[3] ^ counter[2] ^ counter[1] ^ counter[0]);

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
    end
    else begin
        counter <= {counter[2:0], feedback};
        // Special cases to maintain binary sequence
        case (counter)
            4'b0000: counter <= 4'b0001;
            4'b1000: counter <= 4'b1001;
            default: counter <= {counter[2:0], feedback};
        endcase
    end
end

assign q = counter;

endmodule