module div_16bit #(
    parameter DIVIDEND_WIDTH = 16,
    parameter DIVISOR_WIDTH = 8
) (
    input [DIVIDEND_WIDTH-1:0] A,
    input [DIVISOR_WIDTH-1:0] B,
    output [DIVIDEND_WIDTH-1:0] result,
    output [DIVISOR_WIDTH-1:0] odd
);

    reg [DIVISOR_WIDTH:0] temp;  // Temporary remainder storage (1 extra bit for carry)
    reg [DIVIDEND_WIDTH-1:0] quot;
    integer i;

    always @(*) begin
        temp = {DIVISOR_WIDTH+1{1'b0}};  // Initialize to zero
        quot = {DIVIDEND_WIDTH{1'b0}};
        
        for (i = DIVIDEND_WIDTH-1; i >= 0; i = i-1) begin
            temp = {temp[DIVISOR_WIDTH-1:0], A[i]};  // Shift in next dividend bit
            
            if (temp >= B) begin
                temp = temp - B;
                quot[i] = 1'b1;
            end else begin
                quot[i] = 1'b0;
            end
        end
    end

    assign result = quot;
    assign odd = temp[DIVISOR_WIDTH-1:0];

endmodule