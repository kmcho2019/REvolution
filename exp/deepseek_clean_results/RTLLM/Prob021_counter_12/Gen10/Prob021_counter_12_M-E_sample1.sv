module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output reg [3:0] out      // Counter output
);

// Gray code encoding for states 0-11
localparam [3:0] S0  = 4'b0000,
                 S1  = 4'b0001,
                 S2  = 4'b0011,
                 S3  = 4'b0010,
                 S4  = 4'b0110,
                 S5  = 4'b0111,
                 S6  = 4'b0101,
                 S7  = 4'b0100,
                 S8  = 4'b1100,
                 S9  = 4'b1101,
                 S10 = 4'b1111,
                 S11 = 4'b1110;

reg [3:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    if (!valid_count) begin
        next_state = state;  // Hold current state when not enabled
    end else begin
        case (state)
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
end

// Convert gray code to binary for output
always @(*) begin
    case (state)
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