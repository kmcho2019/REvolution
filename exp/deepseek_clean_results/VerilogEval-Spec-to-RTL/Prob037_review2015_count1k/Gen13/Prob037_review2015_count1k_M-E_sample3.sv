module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg [3:0] prescaler;  // Counts 0-9 (4 bits)
reg [6:0] main_count; // Counts 0-99 (7 bits)

wire prescaler_max = (prescaler == 4'd9);
wire main_count_max = (main_count == 7'd99);
wire terminal_count = prescaler_max & main_count_max;

always @(posedge clk) begin
    if (reset) begin
        prescaler <= 4'b0;
        main_count <= 7'b0;
    end
    else begin
        if (prescaler_max) begin
            prescaler <= 4'b0;
            if (main_count_max) begin
                main_count <= 7'b0;
            end
            else begin
                main_count <= main_count + 1'b1;
            end
        end
        else begin
            prescaler <= prescaler + 1'b1;
        end
    end
end

// Combine counters to form final output
always @(*) begin
    q = {main_count, prescaler};
end

endmodule