module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] match_counter;
    reg found;
    reg expected_bit;

    always @(posedge clk) begin
        if (reset) begin
            match_counter <= 2'b0;
            found <= 1'b0;
            expected_bit <= 1'b1; // First bit of 1101 sequence
        end else if (!found) begin
            if (data == expected_bit) begin
                // Progress through sequence: 1->1->0->1
                case (match_counter)
                    2'b00: expected_bit <= 1'b1;  // After first 1, expect second 1
                    2'b01: expected_bit <= 1'b0;   // After 11, expect 0
                    2'b10: expected_bit <= 1'b1;   // After 110, expect 1
                    default: expected_bit <= 1'b1;
                endcase
                
                if (match_counter == 2'b10 && data == 1'b1) begin
                    found <= 1'b1;  // Complete sequence 1101 detected
                end else begin
                    match_counter <= match_counter + 1;
                end
            end else begin
                match_counter <= 2'b0;
                expected_bit <= 1'b1; // Reset to looking for first '1'
            end
        end
    end

    assign start_shifting = found;

endmodule