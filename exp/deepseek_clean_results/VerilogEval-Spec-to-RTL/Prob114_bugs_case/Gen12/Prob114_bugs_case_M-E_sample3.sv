module TopModule (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

// Lower nibble check (last hex digit)
wire lower_nibble_valid;
wire [3:0] lower_nibble_key;
assign lower_nibble_valid = (code[3:0] == 4'h5) |  // 0,4
                            (code[3:0] == 4'h6) |  // 1,5,7,9
                            (code[3:0] == 4'he) |  // 2,3,6,8
                            (code[3:0] == 4'hd);   // 7
assign lower_nibble_key = (code[3:0] == 4'h5) ? 4'd0 :
                          (code[3:0] == 4'h6) ? 4'd1 :
                          (code[3:0] == 4'he) ? 4'd2 :
                          (code[3:0] == 4'hd) ? 4'd7 : 4'd0;

// Upper nibble validation
wire upper_nibble_valid;
assign upper_nibble_valid = 
    ((code[7:4] == 4'h4) & (code[3:0] == 4'h5) |  // 0 (45)
    ((code[7:4] == 4'h1) & (
        (code[3:0] == 4'h6) |  // 1 (16)
        (code[3:0] == 4'he) |  // 2 (1e), 3 (26)
        (code[3:0] == 4'h6)    // 4 (25)
    )) |
    ((code[7:4] == 4'h2) & (
        (code[3:0] == 4'he) |  // 5 (2e)
        (code[3:0] == 4'h6)    // 6 (36)
    )) |
    ((code[7:4] == 4'h3) & (
        (code[3:0] == 4'hd) |  // 7 (3d)
        (code[3:0] == 4'he) |  // 8 (3e)
        (code[3:0] == 4'h6)    // 9 (46)
    ));

// Final output logic
always @(*) begin
    if (upper_nibble_valid & lower_nibble_valid) begin
        valid = 1'b1;
        case(code)
            8'h45: out = 4'd0;
            8'h16: out = 4'd1;
            8'h1e: out = 4'd2;
            8'h26: out = 4'd3;
            8'h25: out = 4'd4;
            8'h2e: out = 4'd5;
            8'h36: out = 4'd6;
            8'h3d: out = 4'd7;
            8'h3e: out = 4'd8;
            8'h46: out = 4'd9;
            default: begin
                valid = 1'b0;
                out = 4'd0;
            end
        endcase
    end else begin
        valid = 1'b0;
        out = 4'd0;
    end
end

endmodule