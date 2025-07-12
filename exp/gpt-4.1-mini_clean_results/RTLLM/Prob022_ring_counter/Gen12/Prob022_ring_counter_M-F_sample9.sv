module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] position;  // 3 bits to count from 0 to 7

    // Sequential logic: update position on clock or reset
    always @(posedge clk) begin
        if (reset)
            position <= 3'd0;
        else if (position == 3'd7)
            position <= 3'd0;
        else
            position <= position + 3'd1;
    end

    // Combinational logic: generate one-hot output from position without shift operator
    always @(*) begin
        case (position)
            3'd0: out = 8'b0000_0001;
            3'd1: out = 8'b0000_0010;
            3'd2: out = 8'b0000_0100;
            3'd3: out = 8'b0000_1000;
            3'd4: out = 8'b0001_0000;
            3'd5: out = 8'b0010_0000;
            3'd6: out = 8'b0100_0000;
            3'd7: out = 8'b1000_0000;
            default: out = 8'b0000_0001; // default safety
        endcase
    end

endmodule