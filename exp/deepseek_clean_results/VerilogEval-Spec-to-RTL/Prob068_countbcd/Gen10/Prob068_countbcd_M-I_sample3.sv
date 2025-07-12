module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] ones_next = (counter[3:0] == 4'd9) ? 4'd0 : (counter[3:0] + 1);
    wire [3:0] tens_next = (counter[7:4] == 4'd9) ? 4'd0 : (counter[7:4] + 1);
    wire [3:0] hundreds_next = (counter[11:8] == 4'd9) ? 4'd0 : (counter[11:8] + 1);
    wire [3:0] thousands_next = (counter[15:12] == 4'd9) ? 4'd0 : (counter[15:12] + 1);
    
    assign q = counter;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            ena <= 3'b0;
        end
        else begin
            // Register enable signals
            ena[0] <= (counter[3:0] == 4'd9);
            ena[1] <= (counter[7:0] == 8'h99);
            ena[2] <= (counter[11:0] == 12'h999);
            
            // Update counter with flattened logic
            counter[3:0] <= ones_next;
            
            if (ena[0]) begin
                counter[7:4] <= tens_next;
                
                if (ena[1]) begin
                    counter[11:8] <= hundreds_next;
                    
                    if (ena[2]) begin
                        counter[15:12] <= thousands_next;
                    end
                end
            end
        end
    end

endmodule