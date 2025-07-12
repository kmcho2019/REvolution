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

reg [7:0] SR; // Shift register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [3:0] cnt; // Counter
reg start_cnt; // Flag to start division process
reg [8:0] temp_SR; // Temporary shift register for calculations

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all registers
        res_valid <= 0;
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else if (opn_valid && !res_valid) begin
        // Initialize registers when a new operation is requested
        SR <= {1'b0, dividend[7:0]};
        if (sign && dividend[7]) begin
            NEG_DIVISOR <= ~(8'd0 - divisor[7:0]) + 1;
        end else begin
            NEG_DIVISOR <= ~(8'd0 - divisor[7:0]);
        end
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Perform division process
        if (cnt == 8'd8) begin
            // Division is complete
            cnt <= 0;
            start_cnt <= 0;
            if (sign && dividend[7]) begin
                // Handle signed division
                result <= {SR[15:8], SR[7:0]};
            end else begin
                result <= {SR[15:8], SR[7:0]};
            end
            res_valid <= 1;
        end else begin
            // Perform subtraction and update shift register
            temp_SR = SR - NEG_DIVISOR;
            if (temp_SR[8]) begin
                // Borrow occurred, set carry-out to 1
                SR <= {1'b1, SR[7:0]};
            end else begin
                // No borrow, set carry-out to 0
                SR <= {1'b0, SR[7:0]};
            end
            // Update SR based on carry-out
            SR <= {SR[7], temp_SR[7:0]};
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        // Result is valid, wait for it to be consumed
        if (!opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule