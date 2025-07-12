module TopModule(output zero);
    reg [31:0] counter;
    wire counter_lsb;
    
    always @(*) begin
        counter = counter + 1;
    end
    
    assign counter_lsb = counter[0];
    assign zero = counter_lsb & ~counter_lsb;
endmodule