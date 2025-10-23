module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;
reg [2:0] ena_reg;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
        ena_reg <= 3'b000;
    end else begin
        // Calculate the next state
        reg [15:0] next_count;
        reg [2:0] next_ena;
        
        next_count = count;
        next_ena = 3'b000;
        
        // Increment ones place
        if (count[3:0] == 4'd9) begin
            next_count[3:0] = 4'd0;
            next_ena[0] = 1'b1; // Enable tens place
        end else begin
            next_count[3:0] = count[3:0] + 1;
        end
        
        // Increment tens place
        if (next_ena[0] == 1'b1 && count[7:4] == 4'd9) begin
            next_count[7:4] = 4'd0;
            next_ena[1] = 1'b1; // Enable hundreds place
        end else if (next_ena[0] == 1'b1) begin
            next_count[7:4] = count[7:4] + 1;
        end
        
        // Increment hundreds place
        if (next_ena[1] == 1'b1 && count[11:8] == 4'd9) begin
            next_count[11:8] = 4'd0;
            next_ena[2] = 1'b1; // Enable thousands place
        end else if (next_ena[1] == 1'b1) begin
            next_count[11:8] = count[11:8] + 1;
        end
        
        // Increment thousands place
        if (next_ena[2] == 1'b1 && count[15:12] == 4'd9) begin
            next_count[15:12] = 4'd0;
        end else if (next_ena[2] == 1'b1) begin
            next_count[15:12] = count[15:12] + 1;
        end
        
        count <= next_count;
        ena_reg <= next_ena;
    end
end

assign q = count;
assign ena = ena_reg;

endmodule