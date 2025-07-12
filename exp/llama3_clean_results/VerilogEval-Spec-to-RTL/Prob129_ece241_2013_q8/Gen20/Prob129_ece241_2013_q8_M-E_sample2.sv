module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // 0: Initial, 1: First "1" detected, 2: Second "1" detected
reg prev_x; // Previous value of x

always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 0;
        prev_x <= 0;
    end else begin
        case (state)
            0: begin
                if (x == 1) begin
                    state <= 1;
                end
                prev_x <= x;
            end
            1: begin
                if (x == 0) begin
                    state <= 2;
                end else begin
                    state <= 1;
                end
                prev_x <= x;
            end
            2: begin
                if (x == 1) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
                prev_x <= x;
            end
        endcase
    end
end

assign z = (state == 1 && prev_x == 0);

endmodule