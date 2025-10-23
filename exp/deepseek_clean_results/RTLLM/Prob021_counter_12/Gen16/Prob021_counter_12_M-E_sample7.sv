module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// One-hot encoded state definitions
localparam [11:0] STATE0  = 12'b000000000001;
localparam [11:0] STATE1  = 12'b000000000010;
localparam [11:0] STATE2  = 12'b000000000100;
localparam [11:0] STATE3  = 12'b000000001000;
localparam [11:0] STATE4  = 12'b000000010000;
localparam [11:0] STATE5  = 12'b000000100000;
localparam [11:0] STATE6  = 12'b000001000000;
localparam [11:0] STATE7  = 12'b000010000000;
localparam [11:0] STATE8  = 12'b000100000000;
localparam [11:0] STATE9  = 12'b001000000000;
localparam [11:0] STATE10 = 12'b010000000000;
localparam [11:0] STATE11 = 12'b100000000000;

reg [11:0] current_state, next_state;

// State transition logic
always @(*) begin
    if (!rst_n) begin
        next_state = STATE0;
    end
    else if (valid_count) begin
        case (current_state)
            STATE0:  next_state = STATE1;
            STATE1:  next_state = STATE2;
            STATE2:  next_state = STATE3;
            STATE3:  next_state = STATE4;
            STATE4:  next_state = STATE5;
            STATE5:  next_state = STATE6;
            STATE6:  next_state = STATE7;
            STATE7:  next_state = STATE8;
            STATE8:  next_state = STATE9;
            STATE9:  next_state = STATE10;
            STATE10: next_state = STATE11;
            STATE11: next_state = STATE0;
            default: next_state = STATE0;
        endcase
    end
    else begin
        next_state = current_state;
    end
end

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= STATE0;
    end
    else begin
        current_state <= next_state;
    end
end

// Output logic
always @(*) begin
    case (current_state)
        STATE0:  out = 4'd0;
        STATE1:  out = 4'd1;
        STATE2:  out = 4'd2;
        STATE3:  out = 4'd3;
        STATE4:  out = 4'd4;
        STATE5:  out = 4'd5;
        STATE6:  out = 4'd6;
        STATE7:  out = 4'd7;
        STATE8:  out = 4'd8;
        STATE9:  out = 4'd9;
        STATE10: out = 4'd10;
        STATE11: out = 4'd11;
        default: out = 4'd0;
    endcase
end

endmodule