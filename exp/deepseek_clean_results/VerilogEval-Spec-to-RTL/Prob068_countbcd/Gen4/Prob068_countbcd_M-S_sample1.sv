module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    
    // Parallel enable generation
    assign ena[0] = (counter[3:0] == 4'd9);
    assign ena[1] = (counter[7:4] == 4'd9) & ena[0];
    assign ena[2] = (counter[11:8] == 4'd9) & ena[1];
    
    assign q = counter;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Ones digit always increments
            if (counter[3:0] == 4'd9) begin
                counter[3:0] <= 4'd0;
            end else begin
                counter[3:0] <= counter[3:0] + 4'd1;
            end
            
            // Tens digit increments when ones rolls over
            if (ena[0]) begin
                if (counter[7:4] == 4'd9) begin
                    counter[7:4] <= 4'd0;
                end else begin
                    counter[7:4] <= counter[7:4] + 4'd1;
                end
            end
            
            // Hundreds digit increments when tens rolls over
            if (ena[1]) begin
                if (counter[11:8] == 4'd9) begin
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
        end
    end

endmodule