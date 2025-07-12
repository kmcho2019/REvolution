module TopModule (
    input         clk,
    input         reset,
    output [3:0]  q
);

    reg [9:0] state; // one-hot encoded states for counts 1 to 10

    // State update: shift left with wrap-around
    always @(posedge clk) begin
        if (reset)
            state <= 10'b0000000001; // count = 1
        else begin
            if (state[9])
                state <= 10'b0000000001; // wrap from 10 to 1
            else
                state <= state << 1;
        end
    end

    // Combinational binary encoder from one-hot state to binary count
    // Index 0 corresponds to count=1, index 9 to count=10
    reg [3:0] count_bin;
    integer i;
    always @(*) begin
        count_bin = 4'd0;
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i])
                count_bin = i + 1;
        end
    end

    assign q = count_bin;

endmodule