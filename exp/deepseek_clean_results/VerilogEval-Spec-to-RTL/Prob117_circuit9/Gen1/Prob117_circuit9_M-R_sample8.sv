module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;
reg initialized = 0;

// Initialize counter to 4 on first clock edge
always @(posedge clk) begin
    if (!initialized) begin
        counter <= 3'b100;
        initialized <= 1;
    end
    else if (!a) begin
        if (counter == 3'b110)
            counter <= 3'b000;
        else
            counter <= counter + 1;
    end
end

assign q = counter;

endmodule