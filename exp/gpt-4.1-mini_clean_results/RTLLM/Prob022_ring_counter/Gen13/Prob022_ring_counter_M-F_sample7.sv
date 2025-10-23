module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] position;  // Position of the single set bit [0..7]

    // Sequential logic to update position on clock and reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0;
        end else begin
            if (position == 3'd7)
                position <= 3'd0;
            else
                position <= position + 3'd1;
        end
    end

    // Combinational logic to generate one-hot output from position using case statement
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
            default: out = 8'b0000_0001; // default safe fallback
        endcase
    end

endmodule