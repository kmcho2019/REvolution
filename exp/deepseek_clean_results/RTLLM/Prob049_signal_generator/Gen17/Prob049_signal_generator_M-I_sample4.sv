module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter; // 6-bit counter for automatic direction change

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 6'b0;
    end else begin
        // Automatically reverses direction at boundaries
        if (counter[5]) begin // When MSB set (underflow)
            counter <= counter + 6'd1;
        end else begin
            counter <= counter - 6'd1;
        end
    end
end

// Output is lower 5 bits of counter
always @(*) begin
    wave = counter[4:0];
end

endmodule