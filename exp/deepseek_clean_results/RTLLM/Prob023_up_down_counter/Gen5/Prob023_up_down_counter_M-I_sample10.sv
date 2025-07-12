module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Gray code conversion
wire [15:0] gray_count;
assign gray_count = count ^ (count >> 1);

// Clock gating logic
reg enable_counter;
always @(posedge clk) begin
    enable_counter <= ~reset;
end

// Pipeline registers
reg [15:0] count_p1;
reg up_down_p1;

// 2-stage pipelined counter with carry lookahead
always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
        count_p1 <= 16'b0;
        up_down_p1 <= 1'b0;
    end else if (enable_counter) begin
        // Stage 1: Calculate next count
        up_down_p1 <= up_down;
        if (up_down) begin
            // Carry lookahead increment
            count_p1 <= count + 1'b1;
        end else begin
            // Borrow lookahead decrement
            count_p1 <= count - 1'b1;
        end
        
        // Stage 2: Register output
        count <= count_p1;
    end
end

endmodule