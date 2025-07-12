module TopModule(
    input clk,
    input a,
    output reg q
);

// Counter to track the number of 'a' low states
reg [1:0] counter;

// Threshold to determine when 'q' should be high
localparam THRESHOLD = 2'd1;

// Increment or reset counter based on 'a' at the positive edge of 'clk'
always @(posedge clk) begin
    if (a) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

// Set 'q' based on the counter value
always @(*) begin
    if (counter >= THRESHOLD) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule