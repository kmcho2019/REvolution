module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [15:0] next_counter;
    wire [15:0] corrected_counter;
    
    // Next counter value (increment by 1)
    assign next_counter = counter + 16'd1;
    
    // BCD correction logic for each digit
    assign corrected_counter[3:0] = (counter[3:0] == 4'd9 && next_counter[3:0] == 4'd10) ? 4'd0 : next_counter[3:0];
    assign corrected_counter[7:4] = (counter[7:4] == 4'd9 && next_counter[7:4] == 4'd10) ? 4'd0 : 
                                  (next_counter[3:0] == 4'd10) ? next_counter[7:4] + 4'd1 : next_counter[7:4];
    assign corrected_counter[11:8] = (counter[11:8] == 4'd9 && next_counter[11:8] == 4'd10) ? 4'd0 : 
                                   (next_counter[7:4] == 4'd10) ? next_counter[11:8] + 4'd1 : next_counter[11:8];
    assign corrected_counter[15:12] = (counter[15:12] == 4'd9 && next_counter[15:12] == 4'd10) ? 4'd0 : 
                                    (next_counter[11:8] == 4'd10) ? next_counter[15:12] + 4'd1 : next_counter[15:12];
    
    // Enable signal generation
    assign ena[0] = (counter[3:0] == 4'd9) && (next_counter[3:0] == 4'd10);
    assign ena[1] = (counter[7:4] == 4'd9) && (next_counter[7:4] == 4'd10);
    assign ena[2] = (counter[11:8] == 4'd9) && (next_counter[11:8] == 4'd10);
    
    // Main counter update
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            counter <= corrected_counter;
        end
    end
    
    // Output the corrected BCD value
    assign q = counter;

endmodule