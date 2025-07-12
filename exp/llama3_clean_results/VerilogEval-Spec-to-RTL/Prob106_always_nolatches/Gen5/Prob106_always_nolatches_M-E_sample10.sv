module TopModule (
    input  wire [15:0] scancode,
    output reg         left,
    output reg         down,
    output reg         right,
    output reg         up
);

    always @(*) begin
        left  = (scancode == 16'he06b);
        down = (scancode == 16'he072);
        right = (scancode == 16'he074);
        up   = (scancode == 16'he075);
    end

endmodule