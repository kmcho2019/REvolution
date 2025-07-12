module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [15:0] shift_register; // To hold the dividend shifted left by one bit
reg [7:0] neg_divisor; // To hold the negated absolute value of the divisor
reg [2:0] counter; // Counter for the division process
reg start_cnt; // Flag to start the division
reg res_valid_reg; // Register for res_valid
reg [7:0] quotient; // Register to hold the quotient
reg [1:0] state; // State machine state

parameter IDLE = 2'b00, DIVIDING = 2'b01, RESULT_READY = 2'b10;

// Sequential logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        shift_register <= 0;
        neg_divisor <= 0;
        counter <= 0;
        start_cnt <= 0;
        res_valid_reg <= 0;
        quotient <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid_reg) begin
                    if (sign) begin
                        // Signed division
                        shift_register <= ({dividend[7]? {8{1'b1}} : {8{1'b0}}} + dividend) << 1;
                        neg_divisor <= ~({divisor[7]? {8{1'b1}} : {8{1'b0}}} + divisor) + 1;
                    end else begin
                        // Unsigned division
                        shift_register <= dividend << 1;
                        neg_divisor <= ~divisor + 1;
                    end
                    counter <= 1;
                    start_cnt <= 1;
                    state <= DIVIDING;
                end
            end
            DIVIDING: begin
                if (counter == 8) begin
                    // Division complete
                    counter <= 0;
                    start_cnt <= 0;
                    res_valid_reg <= 1;
                    state <= RESULT_READY;
                end else begin
                    // Perform subtraction and update shift register
                    reg [16:0] subtraction;
                    subtraction = {1'b0, shift_register} - {8'b0, neg_divisor};
                    if (subtraction[16]) begin
                        // No borrow
                        shift_register <= {1'b0, shift_register[15:1]};
                        quotient <= quotient << 1;
                    end else begin
                        // Borrow
                        shift_register <= {subtraction[15], shift_register[15:1]};
                        quotient <= (quotient << 1) | 1'b1;
                    end
                    counter <= counter + 1;
                end
            end
            RESULT_READY: begin
                if (!opn_valid) begin
                    state <= IDLE;
                    res_valid_reg <= 0;
                end
            end
        endcase
    end
end

// Combinational logic for output
assign result = {shift_register[15:8], quotient};
assign res_valid = res_valid_reg;

endmodule