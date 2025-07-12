module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;
reg [2:0] next_counter;

always @(posedge clk) begin
    counter <= next_counter;
end

always @(*) begin
    if (~a) begin
        if (counter == 4) begin
            next_counter = 0;
        end else if (counter == 7) begin
            next_counter = 0;
        end else begin
            next_counter = counter + 1;
        end
    end else begin
        next_counter = counter;
    end
end

assign q = counter;

initial begin
    counter = 4; // Initialize q to 4 (100 in binary) on power-up
end

endmodule