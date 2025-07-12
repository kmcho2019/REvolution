module TopModule(
    input  wire [15:0] scancode,
    output wire         left,
    output wire         down,
    output wire         right,
    output wire         up
);

reg [15:0] prev_scancode;

always @(*) begin
    if (scancode == 16'he06b) begin
        left = 1'b1;
        down = 1'b0;
        right = 1'b0;
        up = 1'b0;
    end else if (scancode == 16'he072) begin
        left = 1'b0;
        down = 1'b1;
        right = 1'b0;
        up = 1'b0;
    end else if (scancode == 16'he074) begin
        left = 1'b0;
        down = 1'b0;
        right = 1'b1;
        up = 1'b0;
    end else if (scancode == 16'he075) begin
        left = 1'b0;
        down = 1'b0;
        right = 1'b0;
        up = 1'b1;
    end else begin
        left = 1'b0;
        down = 1'b0;
        right = 1'b0;
        up = 1'b0;
    end
end

always @(posedge scancode) begin
    prev_scancode <= scancode;
end

endmodule