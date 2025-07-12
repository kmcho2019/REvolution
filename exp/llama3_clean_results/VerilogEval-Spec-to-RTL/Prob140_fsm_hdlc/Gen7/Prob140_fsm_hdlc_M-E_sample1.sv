module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [2:0] ones_count; // Counter for consecutive ones
reg [2:0] ones_after_reset; // Counter for consecutive ones after reset or flag

always @(posedge clk) begin
    if (reset) begin
        ones_count <= 0;
        ones_after_reset <= 0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        if (in) begin
            ones_count <= ones_count + 1;
            ones_after_reset <= ones_after_reset + 1;
        end else begin
            ones_count <= 0;
            if (ones_after_reset == 5) begin
                disc <= 1; // Discard bit after 5 consecutive ones
            end
            ones_after_reset <= 0;
        end

        if (ones_count == 6 && ~in) begin
            flag <= 1; // Flag after 6 consecutive ones followed by 0
            ones_after_reset <= 0;
        end

        if (ones_count >= 7) begin
            err <= 1; // Error after 7 or more consecutive ones
        end else begin
            err <= 0;
        end
    end
end

always @(posedge clk) begin
    disc <= 0;
    flag <= 0;
end

endmodule