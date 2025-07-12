module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen_one;
    wire next_seen_one;
    wire next_z;
    
    // State transition logic
    assign next_seen_one = seen_one | x;
    
    // Output logic
    assign next_z = seen_one ? ~x : x;
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
            z <= 1'b0;
        end
        else begin
            seen_one <= next_seen_one;
            z <= next_z;
        end
    end

endmodule