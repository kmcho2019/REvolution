module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg dir;  // 1 for increment, 0 for decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 5'd0;
        dir <= 1'b1;  // Initialize direction to increment
    end else begin
        if (dir == 1'b1) begin  // Incrementing
            if (counter == 5'd31) begin
                counter <= counter;
                dir <= 1'b0;  // Switch to decrementing
            end else begin
                counter <= counter + 1'd1;  // Increment counter
            end
        end else begin  // Decrementing
            if (counter == 5'd0) begin
                counter <= counter;
                dir <= 1'b1;  // Switch to incrementing
            end else begin
                counter <= counter - 1'd1;  // Decrement counter
            end
        end
    end
end

assign wave = counter;

endmodule