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
            // Counter logic
            if (in) begin
                if (count < 7) count <= count + 1;
            end else begin
                count <= 0;
            end

            // Output logic - only update when conditions are met
            if (~in) begin
                disc <= (count == 5);
                flag <= (count == 6);
            end else begin
                err <= (count >= 6);
            end
        end
    end

endmodule