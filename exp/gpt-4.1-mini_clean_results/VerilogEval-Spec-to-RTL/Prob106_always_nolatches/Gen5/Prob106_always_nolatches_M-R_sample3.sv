module TopModule (
    input  [15:0] scancode,
    output reg   left,
    output reg   down,
    output reg   right,
    output reg   up
);

    always @* begin
        // Default outputs to 0
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;

        if (scancode[15:8] == 8'hE0) begin
            if (scancode[7:0] == 8'h6B) begin
                left = 1'b1;
            end else if (scancode[7:0] == 8'h72) begin
                down = 1'b1;
            end else if (scancode[7:0] == 8'h74) begin
                right = 1'b1;
            end else if (scancode[7:0] == 8'h75) begin
                up = 1'b1;
            end
        end
    end

endmodule