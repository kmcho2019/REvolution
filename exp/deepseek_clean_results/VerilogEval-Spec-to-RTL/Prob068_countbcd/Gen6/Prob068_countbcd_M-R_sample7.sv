module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    
    // Direct enable signal assignments
    assign ena[0] = (counter[3:0] == 4'd9);
    assign ena[1] = (counter[3:0] == 4'd9) && (counter[7:4] == 4'd9);
    assign ena[2] = (counter[3:0] == 4'd9) && (counter[7:4] == 4'd9) && (counter[11:8] == 4'd9);
    
    // Clock-gated counter updates with combined reset/increment logic
    assign q = counter;
    
    always @(posedge clk) begin
        counter[3:0] <= reset ? 4'd0 : 
                       (counter[3:0] == 4'd9) ? 4'd0 : 
                       counter[3:0] + 1;
                       
        counter[7:4] <= reset ? 4'd0 : 
                       (ena[0] && counter[7:4] == 4'd9) ? 4'd0 : 
                       ena[0] ? counter[7:4] + 1 : 
                       counter[7:4];
                       
        counter[11:8] <= reset ? 4'd0 : 
                        (ena[1] && counter[11:8] == 4'd9) ? 4'd0 : 
                        ena[1] ? counter[11:8] + 1 : 
                        counter[11:8];
                        
        counter[15:12] <= reset ? 4'd0 : 
                         (ena[2] && counter[15:12] == 4'd9) ? 4'd0 : 
                         ena[2] ? counter[15:12] + 1 : 
                         counter[15:12];
    end

endmodule