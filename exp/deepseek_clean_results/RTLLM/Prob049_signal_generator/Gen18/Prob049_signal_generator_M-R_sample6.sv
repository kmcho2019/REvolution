module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg direction;  // 0 = increment, 1 = decrement

wire at_max = (counter == 5'd31);
wire at_min = (counter == 5'd0);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 5'b0;
        direction <= 1'b0;
    end else begin
        if (direction) begin
            counter <= counter - 1;
            if (at_min) direction <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (at_max) direction <= 1'b1;
        end
    end
end

assign wave = counter;

endmodule