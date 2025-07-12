module TopModule (
    input clk,
    input start,
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different,
    output reg done
);

    reg [6:0] counter; // 7 bits for 0-99
    reg first_bit;     // Stores in[0] for circular diff
    
    always @(posedge clk) begin
        if (start) begin
            counter <= 0;
            first_bit <= in[0];
            done <= 0;
        end else if (counter < 100) begin
            // Process current bit pair
            if (counter > 0) begin
                out_both[counter-1] <= in[counter] & in[counter-1];
                out_any[counter] <= in[counter] | in[counter-1];
                out_different[counter-1] <= in[counter] ^ in[counter-1];
            end
            
            // Handle circular case for last bit
            if (counter == 99) begin
                out_different[99] <= in[99] ^ first_bit;
                out_both[99] <= 0; // No left neighbor
                out_any[0] <= 0;   // No right neighbor
                done <= 1;
            end
            
            counter <= counter + 1;
        end
    end

endmodule