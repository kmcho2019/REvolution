module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    reg [2:0] ptr;  // 3-bit pointer (0-7)
    reg load_mode;   // Controls operation mode

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0;
            ptr <= 3'b0;
            load_mode <= 1'b1;  // Start in load mode
        end else begin
            if (load_mode) begin
                // Load all bits simultaneously
                q <= d;
                load_mode <= 1'b0;
            end else begin
                // Rotate through bits one at a time
                q[ptr] <= d[ptr];
                ptr <= ptr + 1;
                if (&ptr) load_mode <= 1'b1;  // Return to load mode after full cycle
            end
        end
    end

endmodule