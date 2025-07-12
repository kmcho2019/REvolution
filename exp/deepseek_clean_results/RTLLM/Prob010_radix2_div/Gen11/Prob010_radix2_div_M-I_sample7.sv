module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result  // {remainder, quotient}
);

localparam IDLE = 1'b0;
localparam BUSY = 1'b1;

reg state;
reg [3:0] cnt;
reg [15:0] sr;   // shift register: {remainder, quotient}
reg [7:0] divisor_mag;
reg result_sign;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        sr <= 0;
        res_valid <= 0;
        result <= 0;
        divisor_mag <= 0;
        result_sign <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Calculate result sign and magnitudes
                    result_sign <= sign & (dividend[7] ^ divisor[7]);
                    divisor_mag <= (sign & divisor[7]) ? -divisor : divisor;
                    
                    // Initialize shift register with absolute dividend
                    sr <= {8'b0, (sign & dividend[7]) ? -dividend : dividend};
                    
                    state <= BUSY;
                    cnt <= 0;
                end
            end
            
            BUSY: begin
                if (divisor_mag == 0) begin // Division by zero
                    result <= 16'hFFFF;
                    res_valid <= 1;
                    state <= IDLE;
                end else if (cnt == 8) begin // Division complete
                    // Apply sign correction to results
                    result[15:8] <= result_sign ? -sr[15:8] : sr[15:8];
                    result[7:0] <= result_sign ? -sr[7:0] : sr[7:0];
                    res_valid <= 1;
                    state <= IDLE;
                end else begin // Division step
                    // Perform subtraction and shift
                    if (sr[15:8] >= divisor_mag) begin
                        sr <= {(sr[15:8] - divisor_mag), sr[7:0], 1'b1};
                    end else begin
                        sr <= {sr[14:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule