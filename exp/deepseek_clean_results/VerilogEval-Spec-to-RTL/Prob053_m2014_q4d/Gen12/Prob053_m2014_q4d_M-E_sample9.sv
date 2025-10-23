module TopModule (
    input clk,
    input in,
    output out
);

    reg state = 1'b0;  // Initialize T flip-flop to 0
    wire toggle = in ^ state;
    
    assign out = state;
    
    always @(posedge clk) begin
        if (toggle) begin
            state <= ~state;  // Toggle when inputs differ
        end
    end

endmodule