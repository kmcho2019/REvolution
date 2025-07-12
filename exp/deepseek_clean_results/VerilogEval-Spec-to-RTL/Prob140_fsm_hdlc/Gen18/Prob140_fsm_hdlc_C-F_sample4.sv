module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;
    wire next_err = (count >= 3'd6) & in;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            // Update counter
            if (in) begin
                if (count < 3'd7) count <= count + 1;
            end else begin
                count <= 3'd0;
            end

            // Set outputs
            disc <= (count == 3'd5) & ~in;
            flag <= (count == 3'd6) & ~in;
            err <= next_err;
        end
    end

endmodule