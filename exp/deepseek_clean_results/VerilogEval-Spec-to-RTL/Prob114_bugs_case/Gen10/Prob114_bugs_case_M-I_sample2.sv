module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
);

// Define scancode parameters
localparam CODE_0 = 8'h45;
localparam CODE_1 = 8'h16;
localparam CODE_2 = 8'h1e;
localparam CODE_3 = 8'h26;
localparam CODE_4 = 8'h25;
localparam CODE_5 = 8'h2e;
localparam CODE_6 = 8'h36;
localparam CODE_7 = 8'h3d;
localparam CODE_8 = 8'h3e;
localparam CODE_9 = 8'h46;

reg [7:0] prev_code;

always @(*) begin
    // Only evaluate if input changed
    if (code != prev_code) begin
        prev_code = code;
        
        // Default outputs
        out = 0;
        valid = 0;
        
        // Grouped case evaluation (by high nibble where possible)
        case (code)
            CODE_0: begin out = 0; valid = 1; end
            CODE_1: begin out = 1; valid = 1; end
            CODE_2: begin out = 2; valid = 1; end
            CODE_3: begin out = 3; valid = 1; end
            CODE_4: begin out = 4; valid = 1; end
            CODE_5: begin out = 5; valid = 1; end
            CODE_6: begin out = 6; valid = 1; end
            CODE_7: begin out = 7; valid = 1; end
            CODE_8: begin out = 8; valid = 1; end
            CODE_9: begin out = 9; valid = 1; end
        endcase
    end
end

endmodule