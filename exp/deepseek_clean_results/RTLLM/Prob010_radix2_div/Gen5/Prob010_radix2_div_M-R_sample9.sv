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

// State encoding
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [2:0] cnt;
reg [15:0] sr;  // {remainder, quotient}

// Absolute value calculations
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// Subtraction result for division step
wire [8:0] sub_result = {sr[15:8], sr[7]} + {1'b0, ~abs_divisor} + 9'b1;
wire sub_ok = ~sub_result[8];  // Subtraction successful (no borrow)

// Sign correction signals
wire q_sign = sign & (dividend[7] ^ divisor[7]);
wire r_sign = sign & dividend[7];

// Next state logic
wire start_div = (state == IDLE) & opn_valid & (divisor != 0) & (dividend != 0);
wire div_done = (state == CALC) & (cnt == 3'd7);

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        sr <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (start_div) begin
                    sr <= {8'b0, abs_dividend};
                    cnt <= 0;
                    state <= CALC;
                end else if (opn_valid) begin
                    // Handle special cases immediately
                    res_valid <= 1;
                    result <= (divisor == 0) ? {8'hFF, 8'hFF} : 16'b0;
                end
            end
            
            CALC: begin
                if (div_done) begin
                    // Apply sign correction before finishing
                    sr[15:8] <= r_sign ? -sr[15:8] : sr[15:8];
                    sr[7:0] <= q_sign ? -sr[7:0] : sr[7:0];
                    state <= DONE;
                end else begin
                    // Perform division step
                    sr <= sub_ok ? {sub_result[7:0], sr[6:0], 1'b1} 
                                : {sr[14:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                result <= sr;
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule