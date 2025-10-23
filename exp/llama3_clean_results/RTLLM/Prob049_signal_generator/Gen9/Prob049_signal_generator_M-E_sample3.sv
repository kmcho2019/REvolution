module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg incr;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        incr <= 1'b1;
    end else begin
        if (incr) begin
            counter <= counter + 1;
            if (counter == 31) begin
                incr <= 1'b0;
            end
        end else begin
            counter <= counter - 1;
            if (counter == 0) begin
                incr <= 1'b1;
            end
        end
    end
end

assign wave = counter;

endmodule