module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else begin
            if (in) begin
                if (count < 6)
                    count <= count + 1;
            end else begin
                count <= 0;
            end
        end
    end

    assign disc = (count == 5) && !in;
    assign flag = (count == 6) && !in;
    assign err = (count == 6) && in;

endmodule