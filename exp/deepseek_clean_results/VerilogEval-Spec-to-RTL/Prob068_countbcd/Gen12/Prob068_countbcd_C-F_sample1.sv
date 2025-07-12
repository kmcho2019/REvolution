module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [15:0] q_reg;
    
    // Shared comparison logic for enables
    wire ones_max = (counter[3:0] == 4'd9;
    wire tens_max = (counter[7:4] == 4'd9;
    wire hundreds_max = (counter[11:8] == 4'd9;
    
    assign ena[0] = ones_max;                  // Tens enable
    assign ena[1] = ones_max & tens_max;       // Hundreds enable
    assign ena[2] = ones_max & tens_max & hundreds_max; // Thousands enable
    assign q = q_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            q_reg <= 16'd0;
        end
        else begin
            // Always increment ones digit
            if (ones_max) begin
                counter[3:0] <= 4'd0;
            end else begin
                counter[3:0] <= counter[3:0] + 4'd1;
            end
            
            // Tens digit increments when ones rolls over
            if (ones_max) begin
                if (tens_max) begin
                    counter[7:4] <= 4'd0;
                end else begin
                    counter[7:4] <= counter[7:4] + 4'd1;
                end
            end
            
            // Hundreds digit increments when tens rolls over
            if (ena[1]) begin
                if (hundreds_max) begin
                    counter[11:8] <= 4'd0;
                end else begin
                    counter[11:8] <= counter[11:8] + 4'd1;
                end
            end
            
            // Thousands digit increments when hundreds rolls over
            if (ena[2]) begin
                if (counter[15:12] == 4'd9) begin
                    counter[15:12] <= 4'd0;
                end else begin
                    counter[15:12] <= counter[15:12] + 4'd1;
                end
            end
            
            // Registered output to reduce switching
            q_reg <= counter;
        end
    end

endmodule