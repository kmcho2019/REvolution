module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] pos; // position of the '1' bit: 0..7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pos <= 3'd0;
            out <= 8'b0000_0001;
        end else begin
            // Update position
            pos <= (pos == 3'd7) ? 3'd0 : pos + 3'd1;
            // Update output based on pos
            case (pos)
                3'd0: out <= 8'b0000_0001;
                3'd1: out <= 8'b0000_0010;
                3'd2: out <= 8'b0000_0100;
                3'd3: out <= 8'b0000_1000;
                3'd4: out <= 8'b0001_0000;
                3'd5: out <= 8'b0010_0000;
                3'd6: out <= 8'b0100_0000;
                3'd7: out <= 8'b1000_0000;
                default: out <= 8'b0000_0001; // safe default
            endcase
        end
    end

endmodule