module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    reg [3:0] candidates;
    reg [7:0] temp_min;
    integer i;

    always @(*) begin
        candidates = 4'b1111; // All are candidates initially
        temp_min = 8'hFF;     // Start with maximum value

        // Check each bit from MSB to LSB
        for (i = 7; i >= 0; i = i - 1) begin
            // Count how many candidates have '0' at current bit
            case ({candidates[3] & ~a[i], 
                  candidates[2] & ~b[i],
                  candidates[1] & ~c[i],
                  candidates[0] & ~d[i]})
                4'b1000: begin
                    min = a;
                    return;
                end
                4'b0100: begin
                    min = b;
                    return;
                end
                4'b0010: begin
                    min = c;
                    return;
                end
                4'b0001: begin
                    min = d;
                    return;
                end
                default: begin
                    // Narrow down candidates for next bit
                    candidates[3] = candidates[3] & ~a[i];
                    candidates[2] = candidates[2] & ~b[i];
                    candidates[1] = candidates[1] & ~c[i];
                    candidates[0] = candidates[0] & ~d[i];
                end
            endcase
        end

        // If all bits were equal, return any candidate
        min = (candidates[3]) ? a : 
              (candidates[2]) ? b : 
              (candidates[1]) ? c : d;
    end

endmodule