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
            // Clear outputs by default (reduces power)
            disc <= 0;
            flag <= 0;
            err <= 0;

            // Update counter and detect patterns
            if (in) begin
                if (count < 7)
                    count <= count + 1;
                // Error detection (7+ consecutive 1s)
                if (count >= 6)
                    err <= 1;
            end else begin
                // Pattern detection on 0 after 1s
                if (count == 5)
                    disc <= 1;
                else if (count == 6)
                    flag <= 1;
                count <= 0;
            end
        end
    end

endmodule