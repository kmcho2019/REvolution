module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);
    reg ff0, ff1, ff2, ff3;

    always @(posedge clk) begin
        if (!resetn)
            ff0 <= 1'b0;
        else
            ff0 <= in;
    end

    always @(posedge clk) begin
        if (!resetn)
            ff1 <= 1'b0;
        else
            ff1 <= ff0;
    end

    always @(posedge clk) begin
        if (!resetn)
            ff2 <= 1'b0;
        else
            ff2 <= ff1;
    end

    always @(posedge clk) begin
        if (!resetn)
            ff3 <= 1'b0;
        else
            ff3 <= ff2;
    end

    assign out = ff3;
endmodule