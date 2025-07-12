module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;
    reg count_5, count_6;
    reg next_err;

    // First always block: counter and intermediate logic
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            count_5 <= 1'b0;
            count_6 <= 1'b0;
            next_err <= 1'b0;
        end else begin
            // Update counter
            if (in) begin
                if (count < 3'd7) count <= count + 1;
            end else begin
                count <= 3'd0;
            end

            // Registered comparison signals
            count_5 <= (count == 3'd5);
            count_6 <= (count == 3'd6);
            next_err <= (count >= 3'd6) & in;
        end
    end

    // Second always block: output logic
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            // Conditional output updates
            disc <= count_5 & ~in;
            flag <= count_6 & ~in;
            err <= next_err;
        end
    end

endmodule