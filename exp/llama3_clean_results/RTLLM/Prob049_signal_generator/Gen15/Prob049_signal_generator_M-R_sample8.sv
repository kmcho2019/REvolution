module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg direction; // 0: incrementing, 1: decrementing

wire increment;
wire decrement;

assign increment = (~direction) && (counter < 31);
assign decrement = direction && (counter > 0);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        direction <= 0;
    end else begin
        if (increment) begin
            counter <= counter + 1;
            if (counter == 31) direction <= 1;
        end else if (decrement) begin
            counter <= counter - 1;
            if (counter == 0) direction <= 0;
        end
    end
end

assign wave = counter;

endmodule