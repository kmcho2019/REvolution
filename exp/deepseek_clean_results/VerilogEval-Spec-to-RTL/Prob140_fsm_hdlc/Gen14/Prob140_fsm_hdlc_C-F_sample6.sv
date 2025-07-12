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
            // Default outputs remain unchanged (power optimization)
            
            // Counter and output logic
            if (in) begin
                if (count < 7) begin
                    count <= count + 1;
                end
                // Error detection when count reaches 6 and input is still 1
                if (count >= 6) begin
                    err <= 1;
                end
            end else begin
                // Check for disc and flag conditions
                if (count == 5) begin
                    disc <= 1;
                end else if (count == 6) begin
                    flag <= 1;
                end
                count <= 0;
            end
        end
    end

endmodule