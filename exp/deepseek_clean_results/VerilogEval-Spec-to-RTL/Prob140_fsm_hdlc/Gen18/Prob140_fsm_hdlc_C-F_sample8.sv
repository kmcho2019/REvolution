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
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Counter logic - only increment when input is 1
            if (in) begin
                if (count < 7) count <= count + 1;
            end else begin
                count <= 0;
            end

            // Output logic - set based on current state and input
            disc <= (count == 5) && !in;
            flag <= (count == 6) && !in;
            err <= (count >= 6) && in;
        end
    end

endmodule