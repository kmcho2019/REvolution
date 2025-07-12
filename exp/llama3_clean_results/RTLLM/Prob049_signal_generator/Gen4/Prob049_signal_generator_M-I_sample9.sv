module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg direction;

always @(posedge clk) begin
    if (~rst_n) begin
        counter <= 5'd0;
        direction <= 1'b1; // 1 for increment, 0 for decrement
    end else begin
        if (direction) begin
            if (counter == 5'd31) begin
                counter <= counter;
                direction <= 1'b0;
            end else begin
                counter <= counter + 5'd1;
            end
        end else begin
            if (counter == 5'd0) begin
                counter <= counter;
                direction <= 1'b1;
            end else begin
                counter <= counter - 5'd1;
            end
        end
    end
end

always @(negedge rst_n) begin
    counter <= 5'd0;
    direction <= 1'b1;
end

assign wave = counter;

endmodule