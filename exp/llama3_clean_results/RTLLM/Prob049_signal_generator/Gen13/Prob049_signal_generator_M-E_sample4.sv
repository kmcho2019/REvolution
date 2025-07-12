module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg dir; // 1: decrement, 0: increment
wire [4:0] next_counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        dir <= 0;
    end else begin
        counter <= next_counter;
        if (counter == 31) begin
            dir <= 1;
        end else if (counter == 0) begin
            dir <= 0;
        end
    end
end

assign next_counter = (dir) ? (counter - 1) : (counter + 1);

assign wave = counter;

endmodule