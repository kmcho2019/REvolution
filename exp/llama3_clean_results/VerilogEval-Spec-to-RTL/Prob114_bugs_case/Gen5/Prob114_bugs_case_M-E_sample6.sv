module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    reg [3:0] scancode_map [9:0];
    reg [7:0] scancode_values [9:0];

    initial begin
        // Initialize the scancode map
        scancode_values[0] = 8'h45;
        scancode_values[1] = 8'h16;
        scancode_values[2] = 8'h1e;
        scancode_values[3] = 8'h26;
        scancode_values[4] = 8'h25;
        scancode_values[5] = 8'h2e;
        scancode_values[6] = 8'h36;
        scancode_values[7] = 8'h3d;
        scancode_values[8] = 8'h3e;
        scancode_values[9] = 8'h46;

        scancode_map[0] = 4'd0;
        scancode_map[1] = 4'd1;
        scancode_map[2] = 4'd2;
        scancode_map[3] = 4'd3;
        scancode_map[4] = 4'd4;
        scancode_map[5] = 4'd5;
        scancode_map[6] = 4'd6;
        scancode_map[7] = 4'd7;
        scancode_map[8] = 4'd8;
        scancode_map[9] = 4'd9;
    end

    always @(*) begin
        out = 4'd0;
        valid = 1'b0;
        for (int i = 0; i < 10; i++) begin
            if (code == scancode_values[i]) begin
                out = scancode_map[i];
                valid = 1'b1;
                break;
            end
        end
    end

endmodule