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
reg [3:0] cnt;
reg [15:0] SR;  // {remainder, quotient}

// Absolute values
wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (sign & divisor[7]) ? -divisor : divisor;

// Sign handling
wire quotient_sign = sign & (dividend[7] ^ divisor[7]);

// Division signals
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, -divisor_abs};
wire sub_ok = sub_result[8];  // remainder >= divisor if carry out
wire [15:0] next_SR = sub_ok ? 
    {sub_result[7:0], SR[7:1], 1'b1} : 
    {SR[14:0], 1'b0};

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    if (divisor == 0) begin
                        // Handle divide by zero
                        result <= {dividend, 8'hFF};
                        res_valid <= 1;
                        state <= DONE;
                    end else begin
                        // Initialize division
                        SR <= {8'b0, dividend_abs};
                        cnt <= 0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (cnt == 8) begin
                    // Finalize result with sign handling
                    result <= {
                        (sign & dividend[7]) ? -SR[15:8] : SR[15:8],
                        quotient_sign ? -SR[7:0] : SR[7:0]
                    };
                    res_valid <= 1;
                    state <= DONE;
                end else begin
                    // Perform division step
                    SR <= next_SR;
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                if (opn_valid) begin
                    res_valid <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule