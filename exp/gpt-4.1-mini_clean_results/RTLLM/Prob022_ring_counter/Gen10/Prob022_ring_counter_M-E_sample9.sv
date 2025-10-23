module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] position;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0;  // position = 0 -> LSB set
        end else begin
            position <= position + 3'd1;  // Increment with wrap-around due to 3 bits
        end
    end

    always @(*) begin
        case(position)
            3'd0: out = 8'b0000_0001;
            3'd1: out = 8'b0000_0010;
            3'd2: out = 8'b0000_0100;
            3'd3: out = 8'b0000_1000;
            3'd4: out = 8'b0001_0000;
            3'd5: out = 8'b0010_0000;
            3'd6: out = 8'b0100_0000;
            3'd7: out = 8'b1000_0000;
            default: out = 8'b0000_0001; // default to LSB in case of unexpected value
        endcase
    end

endmodule