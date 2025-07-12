module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] counter;

always @(posedge clock) begin
    if (q) begin
        p <= a;
        if (a) begin
            if (counter < 3) counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end else begin
        p <= 0;
        if (a) counter <= counter + 1;
        if (counter == 2 && a) q <= 1;
    end
end

always @(negedge clock) begin
    if (a && !q) begin
        counter <= 0;
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    counter = 0;
end

endmodule