module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;
    wire [9:0] next_shift;
    
    // Priority encoder for load value
    wire load_bit = |data[9:1] ? (data[9] ? 9 : 
                                data[8] ? 8 :
                                data[7] ? 7 :
                                data[6] ? 6 :
                                data[5] ? 5 :
                                data[4] ? 4 :
                                data[3] ? 3 :
                                data[2] ? 2 :
                                data[1] ? 1 : 0) : 0;
    
    // Next state logic
    assign next_shift = load ? (10'b1 << load_bit) : 
                       {1'b0, shift_reg[9:1]};
    
    // Terminal count is just the MSB
    assign tc = shift_reg[0];
    
    always @(posedge clk) begin
        shift_reg <= next_shift;
    end

endmodule