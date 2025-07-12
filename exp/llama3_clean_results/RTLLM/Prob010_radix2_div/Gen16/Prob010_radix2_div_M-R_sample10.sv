module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] remainder;
reg [7:0] quotient;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_div;

// State machine states
enum logic [1:0] {IDLE, DIVIDE, FINALIZE} state, next_state;

// Combinational logic for state transitions
always_comb begin
    case (state)
        IDLE: begin
            if (opn_valid && !res_valid) begin
                next_state = DIVIDE;
            end else begin
                next_state = IDLE;
            end
        end
        DIVIDE: begin
            if (cnt == 8) begin
                next_state = FINALIZE;
            end else begin
                next_state = DIVIDE;
            end
        end
        FINALIZE: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic for state registers and division process
always_ff @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        remainder <= 0;
        quotient <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_div <= 0;
    end else begin
        state <= next_state;
        
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    remainder <= {1'b0, sign ? (dividend[7] ? (~dividend + 1) : dividend) : dividend};
                    neg_divisor <= sign ? (~divisor + 1) : divisor;
                    start_div <= 1'b1;
                    cnt <= 3'd1;
                end
            end
            DIVIDE: begin
                if (cnt < 8) begin
                    if (remainder[7:0] >= neg_divisor) begin
                        remainder <= {remainder[6:0], 1'b1};
                        quotient <= quotient + (1 << (8 - cnt));
                    end else begin
                        remainder <= {remainder[6:0], 1'b0};
                    end
                    remainder <= remainder - neg_divisor;
                    cnt <= cnt + 1'd1;
                end
            end
            FINALIZE: begin
                res_valid <= 1;
                result <= {remainder, quotient};
                start_div <= 0;
            end
        endcase
        
        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule