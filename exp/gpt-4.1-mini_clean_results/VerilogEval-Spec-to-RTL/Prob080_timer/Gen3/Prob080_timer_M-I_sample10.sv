module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;

// Clock enable signal for counter decrement: active only when load=0 and counter!=0
wire cnt_en = (~load) & (counter != 0);

always @(posedge clk) begin
    if (load)
        counter <= data;
    else if (cnt_en)
        counter <= counter - 1;
    else
        counter <= counter; // hold value (mostly zero)
end

assign tc = (counter == 0);

endmodule