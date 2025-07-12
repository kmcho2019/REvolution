module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// State definitions using one-hot encoding
parameter [11:0] S0  = 12'b000000000001;
parameter [11:0] S1  = 12'b000000000010;
parameter [11:0] S2  = 12'b000000000100;
parameter [11:0] S3  = 12'b000000001000;
parameter [11:0] S4  = 12'b000000010000;
parameter [11:0] S5  = 12'b000000100000;
parameter [11:0] S6  = 12'b000001000000;
parameter [11:0] S7  = 12'b000010000000;
parameter [11:0] S8  = 12'b000100000000;
parameter [11:0] S9  = 12'b001000000000;
parameter [11:0] S10 = 12'b010000000000;
parameter [11:0] S11 = 12'b100000000000;

reg [11:0] current_state, next_state;

// State transition logic
always @(*) begin
    if (!rst_n) begin
        next_state = S0;
    end
    else if (valid_count) begin
        case (current_state)
            S0:  next_state = S1;
            S1:  next_state = S2;
            S2:  next_state = S3;
            S3:  next_state = S4;
            S4:  next_state = S5;
            S5:  next_state = S6;
            S6:  next_state = S7;
            S7:  next_state = S8;
            S8:  next_state = S9;
            S9:  next_state = S10;
            S10: next_state = S11;
            S11: next_state = S0;
            default: next_state = S0;
        endcase
    end
    else begin
        next_state = current_state;
    end
end

// State register update
always @(posedge clk) begin
    current_state <= next_state;
end

// Output encoding
always @(*) begin
    case (current_state)
        S0:  out = 4'b0000;
        S1:  out = 4'b0001;
        S2:  out = 4'b0010;
        S3:  out = 4'b0011;
        S4:  out = 4'b0100;
        S5:  out = 4'b0101;
        S6:  out = 4'b0110;
        S7:  out = 4'b0111;
        S8:  out = 4'b1000;
        S9:  out = 4'b1001;
        S10: out = 4'b1010;
        S11: out = 4'b1011;
        default: out = 4'b0000;
    endcase
end

endmodule