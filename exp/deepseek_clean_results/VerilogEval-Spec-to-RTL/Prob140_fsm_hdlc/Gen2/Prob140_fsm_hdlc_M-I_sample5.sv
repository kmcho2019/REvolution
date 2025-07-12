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
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // Update counter
            if (in) begin
                if (count < 7)
                    count <= count + 1;
            end else begin
                count <= 0;
            end

            // Generate outputs
            if (count == 5 && !in) begin
                disc <= 1;
            end else if (count == 6 && !in) begin
                flag <= 1;
            end else if (count >= 6 && in) begin
                err <= 1;
            end
        end
    end

endmodule