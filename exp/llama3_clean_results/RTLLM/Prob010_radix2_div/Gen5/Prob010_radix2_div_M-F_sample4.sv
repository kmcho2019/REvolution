module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Internal signals
reg [15:0] sr; // Shift register for dividend
reg [7:0] neg_divisor; // Negated divisor for subtraction
reg [2:0] cnt; // Counter for division steps
reg start_cnt; // Flag to start division

// State machine
localparam IDLE = 1'b0;
localparam DIVIDE = 1'b1;
reg state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        start_cnt <= 0;
        res_valid <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    if (sign) begin
                        // Signed division
                        sr <= {1'b0, dividend}; // Initialize shift register
                        neg_divisor <= (~divisor) + 1; // Two's complement of divisor
                    end else begin
                        // Unsigned division
                        sr <= {1'b0, dividend}; // Initialize shift register
                        neg_divisor <= divisor; // Directly use divisor
                    end
                    start_cnt <= 1;
                    cnt <= 1;
                    state <= DIVIDE;
                end
            end
            DIVIDE: begin
                if (cnt == 8) begin
                    // Division complete
                    result <= {sr[15:8], sr[7:0]}; // Remainder in upper 8 bits, quotient in lower 8 bits
                    res_valid <= 1;
                    state <= IDLE;
                end else begin
                    // Perform division step
                    reg [8:0] temp;
                    temp = {1'b0, sr[7:0]} - neg_divisor;
                    if (temp[8]) begin
                        // No borrow, shift left
                        sr <= {temp[7:0], 1'b0};
                    end else begin
                        // Borrow, shift left and insert 1
                        sr <= {1'b1, {7{sr[7]}}};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

// Reset res_valid when opn_valid goes low
always @(posedge clk) begin
    if (rst || !opn_valid) begin
        res_valid <= 0;
    end
end

endmodule