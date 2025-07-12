module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] carry;
    
    assign q = counter;
    
    // Carry prediction logic
    assign carry[0] = (counter[3:0] == 4'd9);  // Ones digit carry
    assign carry[1] = (counter[7:4] == 4'd9) & carry[0];  // Tens digit carry
    assign carry[2] = (counter[11:8] == 4'd9) & carry[1]; // Hundreds digit carry
    assign carry[3] = (counter[15:12] == 4'd9) & carry[2]; // Thousands digit carry
    
    // Enable signals (one cycle before actual increment)
    assign ena[0] = carry[0];  // Tens enable
    assign ena[1] = carry[1];   // Hundreds enable
    assign ena[2] = carry[2];   // Thousands enable
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Ones digit - always increments
            if (carry[0])
                counter[3:0] <= 4'd0;
            else
                counter[3:0] <= counter[3:0] + 1;
            
            // Tens digit - increments only when ones carries
            if (carry[0]) begin
                if (carry[1])
                    counter[7:4] <= 4'd0;
                else
                    counter[7:4] <= counter[7:4] + 1;
            end
            
            // Hundreds digit - increments only when tens carries
            if (carry[1]) begin
                if (carry[2])
                    counter[11:8] <= 4'd0;
                else
                    counter[11:8] <= counter[11:8] + 1;
            end
            
            // Thousands digit - increments only when hundreds carries
            if (carry[2]) begin
                if (carry[3])
                    counter[15:12] <= 4'd0;
                else
                    counter[15:12] <= counter[15:12] + 1;
            end
        end
    end

endmodule