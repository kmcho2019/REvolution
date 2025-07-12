module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

// One-hot encoded state definitions
localparam [11:0] STATE_0  = 12'b000000000001;
localparam [11:0] STATE_1  = 12'b000000000010;
localparam [11:0] STATE_2  = 12'b000000000100;
localparam [11:0] STATE_3  = 12'b000000001000;
localparam [11:0] STATE_4  = 12'b000000010000;
localparam [11:0] STATE_5  = 12'b000000100000;
localparam [11:0] STATE_6  = 12'b000001000000;
localparam [11:0] STATE_7  = 12'b000010000000;
localparam [11:0] STATE_8  = 12'b000100000000;
localparam [11:0] STATE_9  = 12'b001000000000;
localparam [11:0] STATE_10 = 12'b010000000000;
localparam [11:0] STATE_11 = 12'b100000000000;

reg [11:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= STATE_0;
    end else if (valid_count) begin
        case (state)
            STATE_0:  state <= STATE_1;
            STATE_1:  state <= STATE_2;
            STATE_2:  state <= STATE_3;
            STATE_3:  state <= STATE_4;
            STATE_4:  state <= STATE_5;
            STATE_5:  state <= STATE_6;
            STATE_6:  state <= STATE_7;
            STATE_7:  state <= STATE_8;
            STATE_8:  state <= STATE_9;
            STATE_9:  state <= STATE_10;
            STATE_10: state <= STATE_11;
            STATE_11: state <= STATE_0;
            default:  state <= STATE_0;
        endcase
    end
end

// Convert one-hot state to binary output
always @(*) begin
    case (state)
        STATE_0:  out = 4'b0000;
        STATE_1:  out = 4'b0001;
        STATE_2:  out = 4'b0010;
        STATE_3:  out = 4'b0011;
        STATE_4:  out = 4'b0100;
        STATE_5:  out = 4'b0101;
        STATE_6:  out = 4'b0110;
        STATE_7:  out = 4'b0111;
        STATE_8:  out = 4'b1000;
        STATE_9:  out = 4'b1001;
        STATE_10: out = 4'b1010;
        STATE_11: out = 4'b1011;
        default:  out = 4'b0000;
    endcase
end

endmodule