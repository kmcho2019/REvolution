module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    // Known scancodes for digits 0-9
    localparam [7:0] SCANCODES [0:9] = {
        8'h45, // 0
        8'h16, // 1
        8'h1E, // 2
        8'h26, // 3
        8'h25, // 4
        8'h2E, // 5
        8'h36, // 6
        8'h3D, // 7
        8'h3E, // 8
        8'h46  // 9
    };

    integer i;
    reg match_found;
    reg [3:0] matched_digit;

    always @* begin
        match_found = 1'b0;
        matched_digit = 4'd0;
        for(i = 0; i < 10; i = i + 1) begin
            if(code == SCANCODES[i]) begin
                match_found = 1'b1;
                matched_digit = i[3:0];
            end
        end
        if(match_found) begin
            out = matched_digit;
            valid = 1'b1;
        end else begin
            out = 4'd0;
            valid = 1'b0;
        end
    end

endmodule