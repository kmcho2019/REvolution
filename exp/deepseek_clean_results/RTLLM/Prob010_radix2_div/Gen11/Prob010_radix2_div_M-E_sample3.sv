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
localparam PREP = 2'b01;
localparam DIV  = 2'b10;
localparam DONE = 2'b11;

reg [1:0] state;
reg [15:0] RQ;       // {Remainder, Quotient}
reg [7:0] divisor_mag;
reg [3:0] cnt;
reg q_sign, r_sign;
wire [7:0] dividend_mag = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_mag_w = sign & divisor[7] ? -divisor : divisor;
wire [7:0] neg_divisor = -divisor_mag;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        RQ <= 0;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        q_sign <= 0;
        r_sign <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    if (divisor == 0) begin
                        // Handle divide by zero
                        result <= {8'hFF, 8'hFF};
                        res_valid <= 1;
                    end else if (dividend == 0) begin
                        // Early termination for zero dividend
                        result <= 0;
                        res_valid <= 1;
                    end else begin
                        // Initialize division
                        RQ <= {8'b0, dividend_mag};
                        divisor_mag <= divisor_mag_w;
                        q_sign <= sign & (dividend[7] ^ divisor[7]);
                        r_sign <= sign & dividend[7];
                        cnt <= 0;
                        state <= PREP;
                    end
                end
            end
            
            PREP: begin
                // Prepare for first division step
                RQ <= {RQ[14:0], 1'b0};  // Initial shift
                state <= DIV;
            end
            
            DIV: begin
                // Non-restoring division step
                if (RQ[15:8] >= divisor_mag) begin
                    RQ <= {RQ[15:8] + neg_divisor, RQ[7:0], 1'b1};
                end else begin
                    RQ <= {RQ[14:0], 1'b0};
                end
                
                cnt <= cnt + 1;
                if (cnt == 7) state <= DONE;
            end
            
            DONE: begin
                // Final remainder adjustment and sign correction
                if (RQ[15]) begin
                    RQ[15:8] <= RQ[15:8] + divisor_mag;
                end
                
                result <= {
                    r_sign ? -RQ[15:8] : RQ[15:8],
                    q_sign ? -RQ[7:0] : RQ[7:0]
                };
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
        
        // Clear valid if new operation requested
        if (opn_valid && res_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule