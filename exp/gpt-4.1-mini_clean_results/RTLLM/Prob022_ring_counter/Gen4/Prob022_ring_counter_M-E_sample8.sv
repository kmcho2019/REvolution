module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] index;  // 3-bit index to indicate which bit is set

    // State update logic
    always @(posedge clk) begin
        if (reset) begin
            index <= 3'd0;  // Start from LSB
        end else begin
            index <= index + 3'd1; // Wrap-around naturally due to 3-bit width
        end
    end

    // Output decoding logic
    always @(*) begin
        out = 8'b00000000;
        case (index)
            3'd0: out[0] = 1'b1;
            3'd1: out[1] = 1'b1;
            3'd2: out[2] = 1'b1;
            3'd3: out[3] = 1'b1;
            3'd4: out[4] = 1'b1;
            3'd5: out[5] = 1'b1;
            3'd6: out[6] = 1'b1;
            3'd7: out[7] = 1'b1;
            default: out = 8'b00000001; // Default safe fallback
        endcase
    end

endmodule