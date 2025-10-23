module TopModule (
    input        clk,
    input        reset,
    output [3:0] q
);

    reg [9:0] state; // one-hot encoding for count 1 to 10

    // On reset, set state to 1 (bit 0); else shift state left each clock
    // Wrap from bit 9 back to bit 0
    always @(posedge clk) begin
        if (reset)
            state <= 10'b0000000001;
        else if (state[9])
            state <= 10'b0000000001;
        else
            state <= state << 1;
    end

    // Decode one-hot state to binary count 1 to 10
    // Since only one bit is set, binary count = position + 1
    // Use a combinational function to find which bit is set
    reg [3:0] q_reg;
    integer i;
    always @(*) begin
        q_reg = 4'd0;
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i])
                q_reg = i + 1;
        end
    end

    assign q = q_reg;

endmodule