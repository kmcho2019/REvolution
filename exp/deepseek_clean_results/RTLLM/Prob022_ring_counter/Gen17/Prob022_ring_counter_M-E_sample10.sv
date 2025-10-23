module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

// One-hot encoded states
localparam [7:0] STATE_0 = 8'b00000001;
localparam [7:0] STATE_1 = 8'b00000010;
localparam [7:0] STATE_2 = 8'b00000100;
localparam [7:0] STATE_3 = 8'b00001000;
localparam [7:0] STATE_4 = 8'b00010000;
localparam [7:0] STATE_5 = 8'b00100000;
localparam [7:0] STATE_6 = 8'b01000000;
localparam [7:0] STATE_7 = 8'b10000000;

always @(posedge clk) begin
    if (reset) begin
        out <= STATE_0;  // Initialize to first state
    end
    else begin
        case (out)
            STATE_0: out <= STATE_1;
            STATE_1: out <= STATE_2;
            STATE_2: out <= STATE_3;
            STATE_3: out <= STATE_4;
            STATE_4: out <= STATE_5;
            STATE_5: out <= STATE_6;
            STATE_6: out <= STATE_7;
            STATE_7: out <= STATE_0;
            default: out <= STATE_0;  // Handle undefined states
        endcase
    end
end

endmodule