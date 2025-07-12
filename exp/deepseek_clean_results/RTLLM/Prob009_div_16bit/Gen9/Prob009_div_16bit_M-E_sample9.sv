module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Special case: division by zero
    wire zero_divisor = (B == 8'b0);
    
    // Binary search stages
    wire [15:0] candidate [0:4];
    wire [15:0] product [0:4];
    wire [4:0]  decision;
    
    // Initial search range: 0 to 65535 (since 2^16-1 is max)
    assign candidate[0] = 16'h8000;  // Midpoint of initial range
    assign product[0] = candidate[0] * B;
    
    // Stage 1 comparison
    assign decision[4] = (product[0] <= A);
    assign candidate[1] = decision[4] ? 16'hC000 : 16'h4000;
    assign product[1] = candidate[1] * B;
    
    // Stage 2 comparison
    assign decision[3] = (product[1] <= A);
    assign candidate[2] = decision[4] ? 
                        (decision[3] ? 16'hE000 : 16'hA000) :
                        (decision[3] ? 16'h6000 : 16'h2000);
    assign product[2] = candidate[2] * B;
    
    // Stage 3 comparison
    assign decision[2] = (product[2] <= A);
    assign candidate[3] = decision[4] ? 
                        (decision[3] ? 
                            (decision[2] ? 16'hF000 : 16'hD000) :
                            (decision[2] ? 16'hB000 : 16'h9000)) :
                        (decision[3] ? 
                            (decision[2] ? 16'h7000 : 16'h5000) :
                            (decision[2] ? 16'h3000 : 16'h1000));
    assign product[3] = candidate[3] * B;
    
    // Stage 4 comparison
    assign decision[1] = (product[3] <= A);
    
    // Final quotient selection
    wire [15:0] final_candidate = decision[4] ? 
                                (decision[3] ? 
                                    (decision[2] ? 
                                        (decision[1] ? 16'hFFFF : 16'hF800) :
                                        (decision[1] ? 16'hFC00 : 16'hF000)) :
                                (decision[3] ? 
                                    (decision[2] ? 
                                        (decision[1] ? 16'hFE00 : 16'hF400) :
                                        (decision[1] ? 16'hFA00 : 16'hE800)) :
                                (decision[3] ? 
                                    (decision[2] ? 
                                        (decision[1] ? 16'hFF00 : 16'hF200) :
                                        (decision[1] ? 16'hFD00 : 16'hE400)) :
                                    (decision[2] ? 
                                        (decision[1] ? 16'hFF80 : 16'hF100) :
                                        (decision[1] ? 16'hFE80 : 16'hE000));
    
    // Final adjustment
    wire [15:0] final_product = final_candidate * B;
    assign decision[0] = (final_product <= A);
    assign result = zero_divisor ? 16'hFFFF : (decision[0] ? final_candidate : (final_candidate - 1));
    
    // Remainder calculation
    assign odd = zero_divisor ? 8'hFF : (A - (result * B));

endmodule