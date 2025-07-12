module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] count_reg;
    reg [9:0] load_reg;
    reg active;
    
    always @(posedge clk) begin
        // Capture load value immediately
        if (load) begin
            load_reg <= data;
            active <= 1'b1;
        end
        // Countdown logic
        else if (active) begin
            if (count_reg == 10'd1) begin
                active <= 1'b0;
                count_reg <= 10'd0;
            end
            else begin
                count_reg <= count_reg - 1'b1;
            end
        end
        
        // Initialize counter when becoming active
        if (load || (!active && load_reg != count_reg)) begin
            count_reg <= load ? data : load_reg;
        end
    end

    assign tc = ~active;

endmodule