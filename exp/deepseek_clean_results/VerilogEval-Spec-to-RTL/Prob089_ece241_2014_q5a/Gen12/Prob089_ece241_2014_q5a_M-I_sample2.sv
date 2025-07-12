module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // States: 0 = pass through, 1 = invert
    reg state;
    reg last_x;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            last_x <= 1'b0;
        end else begin
            last_x <= x;
            if (state == 1'b0 && x == 1'b1) begin
                state <= 1'b1; // Transition on first '1'
            end
        end
    end

    // Combinational output for better timing
    assign z = (state) ? ~x : x;

endmodule