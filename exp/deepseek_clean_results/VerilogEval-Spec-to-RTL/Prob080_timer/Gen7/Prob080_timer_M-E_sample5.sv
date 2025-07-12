module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;
    
    // Convert data value to thermometer code pattern
    wire [9:0] therm_code = (10'b1 << data) - 1'b1;
    
    assign tc = shift_reg[0];
    
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= therm_code;
        end else begin
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end

endmodule