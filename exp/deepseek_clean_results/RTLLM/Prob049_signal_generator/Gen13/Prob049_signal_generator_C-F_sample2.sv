module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter;  // 6-bit counter (5-bit value + 1-bit direction)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 6'b0;
    end
    else begin
        // Automatic direction change at boundaries
        if ((counter[4:0] == 5'b11111 && !counter[5]) || 
            (counter[4:0] == 5'b00000 && counter[5])) begin
            counter <= {~counter[5], counter[4:0]};
        end
        else begin
            counter <= counter + (counter[5] ? -1 : 1);
        end
    end
end

// Direct assignment of lower 5 bits
assign wave = counter[4:0];

endmodule