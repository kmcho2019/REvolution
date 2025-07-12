module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output reg [3:0] out      // Counter output
);

// One-hot encoded states (12 states)
reg [11:0] state;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= 12'b000000000001;  // State 0
    end
    else if (valid_count) begin
        case (1'b1)  // Synthesis will optimize this to parallel logic
            state[0]:  state <= 12'b000000000010;
            state[1]:  state <= 12'b000000000100;
            state[2]:  state <= 12'b000000001000;
            state[3]:  state <= 12'b000000010000;
            state[4]:  state <= 12'b000000100000;
            state[5]:  state <= 12'b000001000000;
            state[6]:  state <= 12'b000010000000;
            state[7]:  state <= 12'b000100000000;
            state[8]:  state <= 12'b001000000000;
            state[9]:  state <= 12'b010000000000;
            state[10]: state <= 12'b100000000000;
            state[11]: state <= 12'b000000000001;
            default:   state <= 12'b000000000001;
        endcase
    end
end

// Binary output encoding
always @(*) begin
    case (1'b1)  // Priority encoder
        state[0]:  out = 4'b0000;
        state[1]:  out = 4'b0001;
        state[2]:  out = 4'b0010;
        state[3]:  out = 4'b0011;
        state[4]:  out = 4'b0100;
        state[5]:  out = 4'b0101;
        state[6]:  out = 4'b0110;
        state[7]:  out = 4'b0111;
        state[8]:  out = 4'b1000;
        state[9]:  out = 4'b1001;
        state[10]: out = 4'b1010;
        state[11]: out = 4'b1011;
        default:   out = 4'b0000;
    endcase
end

endmodule