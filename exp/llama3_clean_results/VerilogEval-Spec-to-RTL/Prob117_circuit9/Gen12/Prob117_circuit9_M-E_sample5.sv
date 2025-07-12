module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] count;

always @(posedge clk)
begin
    if (!a) 
    begin
        if (count == 7) 
            count <= 0;
        else 
            count <= count + 1;
    end
    else 
        count <= 4;
    q <= count;
end

endmodule