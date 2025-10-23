module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [15:0] SR; // shift register
reg [7:0] NEG_DIVISOR; // negated absolute value of divisor
reg [2:0] cnt; // counter
reg start_cnt; // start counter signal
reg [7:0] abs_dividend; // absolute value of dividend
reg [7:0] abs_divisor; // absolute value of divisor
reg [15:0] temp_result; // temporary result
reg valid_result; // valid result signal

// Initialize variables
initial begin
    SR = 16'd0;
    NEG_DIVISOR = 8'd0;
    cnt = 3'd0;
    start_cnt = 1'd0;
    valid_result = 1'd0;
end

// Save inputs and initialize shift register when operation is valid
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'd0;
        valid_result <= 1'd0;
        SR <= 16'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
    end else if (opn_valid && !res_valid) begin
        // Calculate absolute values
        abs_dividend <= sign ? (~dividend + 1'd1) : dividend;
        abs_divisor <= sign ? (~divisor + 1'd1) : divisor;
        
        // Initialize shift register and NEG_DIVISOR
        SR <= {1'd0, abs_dividend};
        NEG_DIVISOR <= ~abs_divisor + 1'd1;
        
        // Initialize counter and start_cnt
        cnt <= 3'd1;
        start_cnt <= 1'd1;
    end else if (start_cnt) begin
        // Perform division
        if (cnt == 3'd8) begin
            // Division complete
            cnt <= 3'd0;
            start_cnt <= 1'd0;
            valid_result <= 1'd1;
        end else begin
            // Calculate subtraction result
            temp_result <= {SR[14:8], SR[7:0]} - {NEG_DIVISOR, 8'd0};
            
            // Update shift register based on carry-out
            if (temp_result[15]) begin
                SR <= {1'd1, SR[14:1]};
            end else begin
                SR <= {1'd0, (SR[14:8] + {8'd0, SR[7]})[7:0], SR[7:1]};
            end
            
            // Increment counter
            cnt <= cnt + 3'd1;
        end
    end
end

// Generate result
always @ (posedge clk) begin
    if (valid_result) begin
        result <= {SR[14:8], SR[7:0]};
    end
end

// Manage res_valid signal
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'd0;
    end else if (valid_result && !res_valid) begin
        res_valid <= 1'd1;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 1'd0;
    end
end

endmodule