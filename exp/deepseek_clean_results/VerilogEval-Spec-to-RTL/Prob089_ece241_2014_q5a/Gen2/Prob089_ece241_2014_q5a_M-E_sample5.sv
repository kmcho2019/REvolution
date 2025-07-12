module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen_one;
    reg [7:0] buffer;  // Buffer to store bits before first '1'
    reg [2:0] ptr;     // Pointer for buffer operations
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
            buffer <= 8'b0;
            ptr <= 3'b0;
            z <= 1'b0;
        end
        else begin
            if (!seen_one) begin
                // Store bits until first '1' is seen
                buffer[ptr] <= x;
                ptr <= ptr + 1;
                z <= x;
                
                if (x) begin
                    seen_one <= 1'b1;
                end
            end
            else begin
                // Output inverted bits and flush buffer
                if (ptr > 0) begin
                    z <= ~buffer[ptr-1];
                    ptr <= ptr - 1;
                end
                else begin
                    z <= ~x;
                end
            end
        end
    end

endmodule