module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output wire res_valid,
    output wire [15:0] result
);

// State definitions
localparam IDLE = 2'b00;
localparam CALCULATE = 2'b01;
localparam DONE = 2'b10;

// State registers
reg [1:0] state, next_state;
reg [3:0] cnt, next_cnt;
reg [15:0] acc, next_acc;  // {remainder, quotient}
reg [7:0] divisor_reg, next_divisor_reg;
reg q_sign, next_q_sign;
reg r_sign, next_r_sign;

// Output assignments
assign res_valid = (state == DONE);
assign result = { (sign & r_sign) ? -acc[15:8] : acc[15:8],
                  (sign & q_sign) ? -acc[7:0]  : acc[7:0] };

// Combinational next state logic
always @(*) begin
    next_state = state;
    next_cnt = cnt;
    next_acc = acc;
    next_divisor_reg = divisor_reg;
    next_q_sign = q_sign;
    next_r_sign = r_sign;
    
    case (state)
        IDLE: begin
            if (opn_valid) begin
                next_q_sign = sign & (dividend[7] ^ divisor[7]);
                next_r_sign = sign & dividend[7];
                next_divisor_reg = (sign & divisor[7]) ? -divisor : divisor;
                next_acc = {8'b0, (sign & dividend[7]) ? -dividend : dividend};
                next_cnt = 0;
                next_state = CALCULATE;
            end
        end
        
        CALCULATE: begin
            if (acc[15:8] >= divisor_reg) begin
                next_acc = {acc[15:8] - divisor_reg, acc[7:0], 1'b1};
            end else begin
                next_acc = {acc[15:0], 1'b0};
            end
            
            next_cnt = cnt + 1;
            
            if (cnt == 7) begin
                next_state = DONE;
            end
        end
        
        DONE: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential state update
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        acc <= 0;
        divisor_reg <= 0;
        q_sign <= 0;
        r_sign <= 0;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
        acc <= next_acc;
        divisor_reg <= next_divisor_reg;
        q_sign <= next_q_sign;
        r_sign <= next_r_sign;
    end
end

endmodule