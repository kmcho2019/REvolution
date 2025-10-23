module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

reg [15:0] up_count;
reg [15:0] down_count;

// Always increment the up counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        up_count <= 16'b0;
    end else begin
        up_count <= up_count + 1;
    end
end

// Always decrement the down counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        down_count <= 16'b0;
    end else begin
        down_count <= down_count - 1;
    end
end

// Select which counter to output
always @(posedge clk) begin
    count <= up_down ? up_count : down_count;
end

endmodule