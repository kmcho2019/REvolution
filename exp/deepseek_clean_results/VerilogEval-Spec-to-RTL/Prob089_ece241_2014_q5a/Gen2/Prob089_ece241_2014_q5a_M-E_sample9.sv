module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    parameter MAX_BITS = 32;  // Practical limit for serial processing
    reg [MAX_BITS-1:0] shift_reg;
    reg invert_mode;
    integer i;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 0;
            invert_mode <= 0;
        end
        else begin
            if (!invert_mode) begin
                shift_reg <= {x, shift_reg[MAX_BITS-1:1]};
                if (x) invert_mode <= 1;
            end
        end
    end
    
    assign z = invert_mode ? ~x : x;

endmodule