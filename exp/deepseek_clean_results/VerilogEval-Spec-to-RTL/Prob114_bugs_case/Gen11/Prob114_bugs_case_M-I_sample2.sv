module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
);

// Scancode to digit mapping
parameter [7:0] SCANCODES [0:9] = '{8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 
                                    8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46};

reg [7:0] prev_code;

always @(*) begin
    // Default outputs
    out = 0;
    valid = 0;
    
    // Only process if input changed (power optimization)
    if (code != prev_code) begin
        prev_code = code;
        
        // Parallel pattern matching
        for (int i = 0; i < 10; i++) begin
            if (code == SCANCODES[i]) begin
                out = i[3:0];
                valid = 1;
                break;  // Exit early when match found
            end
        end
    end
end

endmodule