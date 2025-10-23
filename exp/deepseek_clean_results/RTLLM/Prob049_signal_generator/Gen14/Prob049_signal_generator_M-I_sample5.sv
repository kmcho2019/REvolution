module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter;  // 6-bit counter (5-bit value + 1-bit direction)
wire at_max = (counter[4:0] == 5'b11111);
wire at_min = (counter[4:0] == 5'b00000);
wire direction = counter[5];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 6'b0;
        wave <= 5'b0;
    end
    else begin
        // Update counter
        if ((at_max && !direction) || (at_min && direction)) begin
            counter <= {~direction, counter[4:0]};
        end
        else begin
            counter <= counter + (direction ? 6'b111111 : 6'b000001); // +1 or -1
        end
        
        // Registered output
        wave <= counter[4:0];
    end
end

endmodule