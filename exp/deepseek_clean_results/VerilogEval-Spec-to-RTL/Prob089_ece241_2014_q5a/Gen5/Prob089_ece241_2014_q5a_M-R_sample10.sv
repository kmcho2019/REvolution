module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg seen_one;
    reg next_seen_one;
    wire next_z;
    
    // Combinational logic for next state and output
    assign next_z = seen_one ? ~x : x;
    always @(*) begin
        next_seen_one = seen_one | x;
    end
    
    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
        end else begin
            seen_one <= next_seen_one;
        end
    end
    
    // Output register
    reg z_reg;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z_reg <= 1'b0;
        end else begin
            z_reg <= next_z;
        end
    end
    
    assign z = z_reg;

endmodule