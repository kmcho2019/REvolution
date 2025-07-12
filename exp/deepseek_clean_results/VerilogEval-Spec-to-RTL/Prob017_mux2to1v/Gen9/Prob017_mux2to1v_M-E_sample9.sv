module TopModule (
    input         clk,        // Added clock input
    input         start,      // Added start signal
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output reg [99:0] out,
    output        done        // Added completion signal
);

    reg [6:0] counter;        // 7-bit counter for 100 positions
    reg [99:0] a_reg, b_reg;  // Input registers
    reg running;               // State control

    always @(posedge clk) begin
        if (start) begin
            a_reg <= a;
            b_reg <= b;
            counter <= 0;
            running <= 1;
            done <= 0;
        end
        else if (running) begin
            // Select current bit
            out <= {out[98:0], (sel ? b_reg[counter] : a_reg[counter])};
            
            // Increment counter
            counter <= counter + 1;
            
            // Check for completion
            if (counter == 7'd99) begin
                running <= 0;
                done <= 1;
            end
        end
    end

endmodule