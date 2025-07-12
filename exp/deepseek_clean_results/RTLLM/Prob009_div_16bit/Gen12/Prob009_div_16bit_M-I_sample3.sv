module div_16bit (
    input clk,
    input reset,
    input start,
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd,
    output reg done
);

    reg [3:0] step;
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [8:0] partial;  // 8-bit remainder + 1 new bit
    
    wire [8:0] next_partial = {partial[7:0], dividend[15-step]};
    wire do_subtract = (next_partial >= {1'b0, divisor});
    wire [8:0] subtracted = next_partial - {1'b0, divisor};

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            step <= 4'd0;
            result <= 16'd0;
            odd <= 8'd0;
            done <= 1'b0;
            dividend <= 16'd0;
            divisor <= 8'd0;
        end else if (start) begin
            step <= 4'd0;
            dividend <= A;
            divisor <= B;
            done <= 1'b0;
            partial <= 9'd0;
        end else if (!done && step < 16) begin
            // Shift in next bit and perform subtraction
            result[15-step] <= do_subtract;
            partial <= do_subtract ? subtracted : next_partial;
            
            // Early termination if remaining bits are zero
            if (dividend[14-step:0] == 0 && !do_subtract) begin
                step <= 4'd15;
                odd <= next_partial[7:0];
            end else begin
                step <= step + 1;
                if (step == 15) odd <= do_subtract ? subtracted[7:0] : next_partial[7:0];
            end
            
            done <= (step == 15);
        end
    end

endmodule