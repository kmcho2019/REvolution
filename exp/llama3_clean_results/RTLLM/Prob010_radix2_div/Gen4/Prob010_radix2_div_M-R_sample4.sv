module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output [15:0] result
);

reg [7:0] abs_dividend;  // Absolute value of the dividend
reg [7:8] abs_divisor;   // Absolute value of the divisor
reg [15:0] sr;           // Shift register
reg [3:0] cnt;            // Counter
reg [7:0] remainder;      // Remainder
reg [7:0] quotient;       // Quotient
reg [1:0] state;          // State machine

// State definitions
localparam IDLE = 2'b00;
localparam PREPARE = 2'b01;
localparam DIVIDE = 2'b10;
localparam COMPLETE = 2'b11;

// Combinational logic for preparing input operands
assign abs_dividend = (sign && dividend[7]) ? (8'hff + dividend) : (sign && ~dividend[7]) ? dividend : dividend;
assign abs_divisor = (sign && divisor[7]) ? (8'hff + divisor) : (sign && ~divisor[7]) ? divisor : divisor;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        sr <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        cnt <= 0;
        res_valid <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    state <= PREPARE;
                    sr <= {1'b0, abs_dividend};
                    cnt <= 1;
                end
            end
            PREPARE: begin
                state <= DIVIDE;
            end
            DIVIDE: begin
                reg [8:0] subtract;
                subtract = {1'b0, sr[15:8]} - abs_divisor;
                if (subtract[8]) begin
                    // No borrow
                    sr <= {1'b0, sr[15:8]} << 1;
                    quotient <= quotient + 1;
                end else begin
                    // Borrow
                    sr <= {1'b1, sr[15:8]} + (abs_divisor << 1);
                end
                cnt <= cnt + 1;
                if (cnt == 8) begin
                    state <= COMPLETE;
                end
            end
            COMPLETE: begin
                remainder <= sr[15:8];
                res_valid <= 1;
                result <= {remainder, quotient};
                state <= IDLE;
                cnt <= 0;
            end
        endcase
    end
end

endmodule