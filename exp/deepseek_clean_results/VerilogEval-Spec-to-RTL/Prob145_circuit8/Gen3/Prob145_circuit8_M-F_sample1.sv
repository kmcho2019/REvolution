module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

reg [1:0] counter;  // Counts consecutive p=1 occurrences

assign p = clock & a;

always @(posedge clock or negedge clock) begin
    if (clock) begin
        // Positive edge behavior
        if (p) begin
            if (counter < 3) counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end else begin
        // Negative edge behavior
        if (a) begin
            q <= 0;
            counter <= 0;
        end else if (counter == 3) begin
            q <= 1;
        end
    end
end

endmodule