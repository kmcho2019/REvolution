module TopModule (
    output zero
);
    reg [0:0] counter = 1'b0;
    
    always @(posedge 1'b0 or negedge 1'b1) begin
        if (1'b0) counter <= counter + 1'b1;  // Never executes
        else counter <= counter - 1'b1;       // Never executes
    end
    
    assign zero = counter;
endmodule