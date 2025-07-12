module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [13:0] count;  // 0-9999
    reg [13:0] prev_count;
    wire [3:0] ones, tens, hundreds, thousands;
    
    // Double dabble binary to BCD conversion
    assign ones = count % 10;
    assign tens = (count / 10) % 10;
    assign hundreds = (count / 100) % 10;
    assign thousands = count / 1000;
    
    // Combine digits into output
    assign q = {thousands, hundreds, tens, ones};
    
    // Generate enable signals when higher digits change
    assign ena[0] = (tens != (prev_count / 10) % 10);
    assign ena[1] = (hundreds != (prev_count / 100) % 10);
    assign ena[2] = (thousands != (prev_count / 1000));
    
    always @(posedge clk) begin
        if (reset) begin
            count <= 14'd0;
            prev_count <= 14'd0;
        end else begin
            prev_count <= count;
            if (count == 14'd9999)
                count <= 14'd0;
            else
                count <= count + 14'd1;
        end
    end

endmodule