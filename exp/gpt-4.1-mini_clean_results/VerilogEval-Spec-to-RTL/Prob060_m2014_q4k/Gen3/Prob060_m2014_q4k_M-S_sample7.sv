module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);
    reg [3:0] s;
    always @(posedge clk) begin
        if (!resetn)
            s <= 4'b0;
        else
            s <= {s[2:0], in};
    end
    assign out = s[3];
endmodule