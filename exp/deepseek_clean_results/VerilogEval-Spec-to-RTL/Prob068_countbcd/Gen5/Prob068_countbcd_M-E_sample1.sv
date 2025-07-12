module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [2:0] pipeline;
    
    // Digit boundaries
    wire ones_roll = (counter[3:0] == 4'd9);
    wire tens_roll = (counter[7:4] == 4'd9);
    wire hundreds_roll = (counter[11:8] == 4'd9);
    
    // Enable signals (combinational)
    assign ena[0] = ones_roll;
    assign ena[1] = ones_roll & tens_roll;
    assign ena[2] = ones_roll & tens_roll & hundreds_roll;
    
    // Output assignment
    assign q = counter;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            pipeline <= 3'd0;
        end else begin
            // Pipeline stage 1: Increment ones digit
            if (counter[3:0] == 4'd9) begin
                counter[3:0] <= 4'd0;
                pipeline[0] <= 1'b1;
            end else begin
                counter[3:0] <= counter[3:0] + 4'd1;
                pipeline[0] <= 1'b0;
            end
            
            // Pipeline stage 2: Process tens digit
            if (pipeline[0]) begin
                if (counter[7:4] == 4'd9) begin
                    counter[7:4] <= 4'd0;
                    pipeline[1] <= 1'b1;
                end else begin
                    counter[7:4] <= counter[7:4] + 4'd1;
                    pipeline[1] <= 1'b0;
                end
            end else begin
                pipeline[1] <= 1'b0;
            end
            
            // Pipeline stage 3: Process hundreds digit
            if (pipeline[1]) begin
                if (counter[11:8] == 4'd9) begin
                    counter[11:8] <= 4'd0;
                    pipeline[2] <= 1'b1;
                end else begin
                    counter[11:8] <= counter[11:8] + 4'd1;
                    pipeline[2] <= 1'b0;
                end
            end else begin
                pipeline[2] <= 1'b0;
            end
            
            // Pipeline stage 4: Process thousands digit
            if (pipeline[2]) begin
                if (counter[15:12] == 4'd9) begin
                    counter[15:12] <= 4'd0;
                end else begin
                    counter[15:12] <= counter[15:12] + 4'd1;
                end
            end
        end
    end

endmodule