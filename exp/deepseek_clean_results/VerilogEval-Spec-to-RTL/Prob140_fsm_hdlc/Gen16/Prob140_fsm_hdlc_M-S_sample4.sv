module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else begin
            if (in) begin
                if (count < 7) count <= count + 1;
            end else begin
                count <= 0;
            end
        end

        // Output logic
        disc = (count == 5) && !in;
        flag = (count == 6) && !in;
        err = (count >= 6) && in;
    end

endmodule