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

            // State transition and output logic
            if (in) begin
                if (count < 6)
                    count <= count + 1;
                else
                    err <= 1;  // 7+ consecutive 1s
            end else begin
                case (count)
                    5: disc <= 1;  // 0111110
                    6: flag <= 1;  // 01111110
                endcase
                count <= 0;
            end
        end
    end

endmodule