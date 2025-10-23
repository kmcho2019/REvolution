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

// States
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [2:0] cnt;        // 0-7 counter
reg [15:0] acc;       // Accumulator: {remainder, quotient}

// Sign handling wires
wire dividend_sign = sign & dividend[7];
wire divisor_sign = sign & divisor[7];
wire q_sign = dividend_sign ^ divisor_sign;
wire r_sign = dividend_sign;

// Absolute values
wire [7:0] abs_dividend = dividend_sign ? -dividend : dividend;
wire [7:0] abs_divisor = divisor_sign ? -divisor : divisor;

// Division step wires
wire [8:0] sub_result = {acc[15:8], 1'b0} + {1'b0, ~abs_divisor + 1'b1};
wire carry_out = ~sub_result[8];  // 1 if result positive
wire [15:0] next_acc = carry_out ? 
    {sub_result[7:0], acc[7:0], 1'b1} : 
    {acc[14:0], 1'b0};

// Division by zero detection
wire div_by_zero = (abs_divisor == 8'b0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        acc <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Initialize with absolute dividend
                    acc <= {8'b0, abs_dividend};
                    cnt <= 0;
                    state <= CALC;
                end
            end
            
            CALC: begin
                if (div_by_zero) begin
                    // Handle division by zero
                    result <= {8'hFF, 8'hFF};
                    res_valid <= 1;
                    state <= DONE;
                end else if (cnt == 3'b111) begin
                    // Final adjustment for non-restoring
                    if (acc[15]) begin
                        acc[15:8] <= acc[15:8] + abs_divisor;
                    end
                    
                    // Apply signs to result
                    result <= {
                        r_sign ? -acc[15:8] : acc[15:8],  // remainder
                        q_sign ? -acc[7:0] : acc[7:0]      // quotient
                    };
                    
                    res_valid <= 1;
                    state <= DONE;
                end else begin
                    // Normal iteration
                    acc <= next_acc;
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                if (!opn_valid) begin
                    res_valid <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule