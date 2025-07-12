module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output valid
);

    // Number of recognized keys
    localparam N = 10;

    // Known scancodes and corresponding digit values
    wire [7:0] scancodes [N-1:0];
    wire [3:0] digits    [N-1:0];

    assign scancodes[0] = 8'h45; assign digits[0] = 4'd0;
    assign scancodes[1] = 8'h16; assign digits[1] = 4'd1;
    assign scancodes[2] = 8'h1e; assign digits[2] = 4'd2;
    assign scancodes[3] = 8'h26; assign digits[3] = 4'd3;
    assign scancodes[4] = 8'h25; assign digits[4] = 4'd4;
    assign scancodes[5] = 8'h2e; assign digits[5] = 4'd5;
    assign scancodes[6] = 8'h36; assign digits[6] = 4'd6;
    assign scancodes[7] = 8'h3d; assign digits[7] = 4'd7;
    assign scancodes[8] = 8'h3e; assign digits[8] = 4'd8;
    assign scancodes[9] = 8'h46; assign digits[9] = 4'd9;

    // One-hot matching vector: one bit per recognized scancode
    wire [N-1:0] match;

    genvar i;
    generate
        for (i=0; i<N; i=i+1) begin : match_gen
            assign match[i] = (code == scancodes[i]);
        end
    endgenerate

    // valid is high if any match bit is set
    assign valid = |match;

    // output digit encoding:
    // If multiple matches (should not happen), priority encoder style pick first
    integer j;
    always @* begin
        out = 4'd0; // default
        for (j=0; j<N; j=j+1) begin
            if (match[j]) begin
                out = digits[j];
            end
        end
    end

endmodule