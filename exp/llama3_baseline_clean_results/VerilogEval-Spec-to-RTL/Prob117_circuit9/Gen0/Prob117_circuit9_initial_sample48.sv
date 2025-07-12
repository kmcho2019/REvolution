module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] counter;

always @(posedge clk) begin
    if (a) begin
        counter <= 1; // Reset counter when a is 1
        q <= 4; // Set output to 4 when a is 1
    end else begin
        counter <= counter + 1; // Increment counter when a is 0
        if (~a && ~($past(a))) begin // Check for transition from 1 to 0
            q <= counter; // Capture counter value when a transitions from 1 to 0
        end
    end
end

endmodule