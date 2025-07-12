module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Individual flip-flop declarations
    reg ff0, ff1, ff2, ff3;

    always @(posedge clk) begin
        if (!resetn) begin
            ff0 <= 1'b0;
            ff1 <= 1'b0;
            ff2 <= 1'b0;
            ff3 <= 1'b0;
        end
        else begin
            ff0 <= in;
            ff1 <= ff0;
            ff2 <= ff1;
            ff3 <= ff2;
        end
    end

    assign out = ff3;

endmodule